import Foundation
import Security

// TODO: Securely stores and retrieves Clerk JWT and tokens using Keychain with kSecAttrAccessibleWhenUnlockedThisDeviceOnly

actor KeychainService {
    enum Key: String, Sendable {
        case clerkToken = "clerk_token"
        case apnsToken = "apns_token"
    }

    func save(key: Key, data: Data) async throws {
        // TODO: Implement Keychain write with kSecAttrAccessibleWhenUnlockedThisDeviceOnly
    }

    func read(key: Key) async throws -> Data? {
        // TODO: Implement Keychain read
        return nil
    }

    func delete(key: Key) async throws {
        // TODO: Implement Keychain delete
    }
}
