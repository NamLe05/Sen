import Foundation

// TODO: Wraps Clerk SDK — handles sign-in/sign-up, JWT refresh, and session lifecycle

@MainActor
@Observable
final class AuthManager {
    var isAuthenticated = false
    var clerkId: String?
    var error: SenError?
}
