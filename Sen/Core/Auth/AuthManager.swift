import Foundation
import Observation
import OSLog
import ClerkKit

@MainActor
@Observable
final class AuthManager {
    var isAuthenticated = false
    var clerkId: String?
    var error: SenError?

    private let keychain = KeychainService()
    private let logger = Logger(subsystem: "com.sen.app", category: "Auth")

    /// Attempts to restore a session from Clerk SDK state or a previously stored JWT in Keychain.
    func restoreSession() async {
        // Check if Clerk already has an active session
        if let user = Clerk.shared.user {
            clerkId = user.id
            isAuthenticated = true
            // Refresh the cached token
            await refreshToken()
            logger.info("Session restored from Clerk")
            return
        }

        // Fall back to Keychain token check
        do {
            let token = try await keychain.readString(key: .clerkToken)
            guard let token, !token.isEmpty else {
                logger.info("No stored session found")
                isAuthenticated = false
                return
            }

            clerkId = extractClerkId(from: token)
            isAuthenticated = true
            logger.info("Session restored from Keychain")
        } catch {
            logger.error("Failed to restore session: \(error.localizedDescription)")
            self.error = .auth("Failed to restore session")
            isAuthenticated = false
        }
    }

    /// Stores the Clerk JWT in Keychain after successful sign-in.
    func signIn(token: String, clerkId: String) async {
        do {
            try await keychain.saveString(token, for: .clerkToken)
            self.clerkId = clerkId
            isAuthenticated = true
            logger.info("Sign-in complete")
        } catch {
            logger.error("Failed to store token: \(error.localizedDescription)")
            self.error = .auth("Failed to complete sign-in")
        }
    }

    /// Clears Keychain tokens, signs out of Clerk, and resets auth state.
    func signOut() async {
        do {
            try await Clerk.shared.auth.signOut()
        } catch {
            logger.error("Clerk sign-out error: \(error.localizedDescription)")
        }

        do {
            try await keychain.delete(key: .clerkToken)
            clerkId = nil
            isAuthenticated = false
            logger.info("Sign-out complete")
        } catch {
            logger.error("Failed to clear token: \(error.localizedDescription)")
            self.error = .auth("Failed to complete sign-out")
        }
    }

    /// Refreshes the cached JWT from Clerk's current session.
    func refreshToken() async {
        do {
            guard let session = Clerk.shared.session else { return }
            if let jwt = try await session.getToken() {
                try await keychain.saveString(jwt, for: .clerkToken)
                logger.info("Token refreshed from Clerk session")
            }
        } catch {
            logger.error("Failed to refresh token: \(error.localizedDescription)")
        }
    }

    /// Retrieves the current JWT for authenticating Convex requests.
    /// Prefers a fresh token from Clerk session, falls back to Keychain cache.
    func currentToken() async -> String? {
        // Try to get a fresh token from Clerk session
        if let session = Clerk.shared.session {
            do {
                if let jwt = try await session.getToken() {
                    // Cache the fresh token
                    try await keychain.saveString(jwt, for: .clerkToken)
                    return jwt
                }
            } catch {
                logger.error("Failed to get fresh token: \(error.localizedDescription)")
            }
        }

        // Fall back to cached token
        do {
            return try await keychain.readString(key: .clerkToken)
        } catch {
            logger.error("Failed to read token: \(error.localizedDescription)")
            self.error = .auth("Failed to read token")
            return nil
        }
    }

    // MARK: - Private

    private func extractClerkId(from token: String) -> String? {
        let segments = token.split(separator: ".")
        guard segments.count == 3,
              let payloadData = base64URLDecode(String(segments[1])),
              let json = try? JSONSerialization.jsonObject(with: payloadData) as? [String: Any],
              let sub = json["sub"] as? String
        else {
            return nil
        }
        return sub
    }

    private func base64URLDecode(_ string: String) -> Data? {
        var base64 = string
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        let remainder = base64.count % 4
        if remainder > 0 {
            base64.append(contentsOf: String(repeating: "=", count: 4 - remainder))
        }
        return Data(base64Encoded: base64)
    }
}
