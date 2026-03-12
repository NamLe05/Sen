import SwiftUI
import ClerkKit

@main
struct SenApp: App {
    @State private var appState = AppState()
    @State private var authManager = AuthManager()
    private let convex: ConvexService

    init() {
        Clerk.configure(publishableKey: SenConfig.clerkPublishableKey)

        let auth = AuthManager()
        self.convex = ConvexService(
            deploymentURL: "https://opulent-sparrow-581.convex.cloud",
            authManager: auth
        )
        _authManager = State(initialValue: auth)
    }

    var body: some Scene {
        WindowGroup {
            ContentView(convex: convex)
                .environment(appState)
                .environment(authManager)
                .environment(Clerk.shared)
        }
    }
}
