import Foundation
import Security
import OSLog

actor KeychainService {
    private let logger = Logger(subsystem: "com.sen.app", category: "Keychain")
    private let serviceName = "com.sen.app"

    enum Key: String, Sendable {
        case clerkToken = "clerk_token"
        case apnsToken = "apns_token"
    }

    enum KeychainError: Error, Sendable {
        case saveFailed(OSStatus)
        case readFailed(OSStatus)
        case deleteFailed(OSStatus)
        case dataConversionFailed
    }

    func save(key: Key, data: Data) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key.rawValue,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            kSecValueData as String: data
        ]

        // Delete any existing item first
        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            logger.error("Keychain save failed for key \(key.rawValue) with status \(status)")
            throw KeychainError.saveFailed(status)
        }
    }

    func saveString(_ value: String, for key: Key) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.dataConversionFailed
        }
        try save(key: key, data: data)
    }

    func read(key: Key) throws -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        switch status {
        case errSecSuccess:
            return result as? Data
        case errSecItemNotFound:
            return nil
        default:
            logger.error("Keychain read failed for key \(key.rawValue) with status \(status)")
            throw KeychainError.readFailed(status)
        }
    }

    func readString(key: Key) throws -> String? {
        guard let data = try read(key: key) else { return nil }
        guard let string = String(data: data, encoding: .utf8) else {
            throw KeychainError.dataConversionFailed
        }
        return string
    }

    func delete(key: Key) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key.rawValue
        ]

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            logger.error("Keychain delete failed for key \(key.rawValue) with status \(status)")
            throw KeychainError.deleteFailed(status)
        }
    }

    func deleteAll() throws {
        for key in [Key.clerkToken, Key.apnsToken] {
            try delete(key: key)
        }
    }
}
