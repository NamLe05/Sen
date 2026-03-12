import Foundation
import Observation

// TODO: Root app state — holds auth status, selected tab, and global error state

@MainActor
@Observable
final class AppState {
    var isAuthenticated = false
    var selectedTab: Tab = .today
    var error: SenError?

    enum Tab: Sendable {
        case today, plan, calendar
    }
}

nonisolated enum SenError: Error, Sendable {
    case network(String)
    case auth(String)
    case unknown(String)
}
