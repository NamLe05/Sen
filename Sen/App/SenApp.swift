import SwiftUI

// TODO: App entry point — configure Clerk auth, Convex client, and notification registration on launch

@main
struct SenApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
        }
    }
}
