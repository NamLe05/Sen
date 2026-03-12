#if DEBUG
import SwiftUI

/// Debug-only toolbar button that clears the Keychain session so onboarding shows on next launch.
struct SignOutButton: View {
    @Environment(AuthManager.self) private var authManager

    var body: some View {
        Button("Sign Out") {
            Task { await authManager.signOut() }
        }
        .foregroundColor(.senError)
    }
}
#endif
