import Foundation
import Observation

/// Holds Clerk credentials between AuthView and the end of new-user onboarding.
/// NotificationsSetupView calls `authManager.signIn()` using these once setup is complete.
@MainActor
@Observable
final class OnboardingSession {
    var pendingToken: String = ""
    var pendingClerkId: String = ""
}
