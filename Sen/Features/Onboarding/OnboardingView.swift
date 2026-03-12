import SwiftUI

struct OnboardingView: View {
    @Environment(AuthManager.self) private var authManager
    @State private var path = NavigationPath()
    @State private var session = OnboardingSession()

    var body: some View {
        NavigationStack(path: $path) {
            WelcomeView(path: $path)
                .navigationBarHidden(true)
                .navigationDestination(for: OnboardingRoute.self) { route in
                    switch route {
                    case .info:
                        InfoView(path: $path)
                            .navigationBarHidden(true)
                    case .auth:
                        AuthView(path: $path)
                            .navigationBarHidden(true)
                    case .profileSetup:
                        ProfileSetupView(path: $path)
                            .navigationBarHidden(true)
                    case .goals:
                        GoalsView(path: $path)
                            .navigationBarHidden(true)
                    case .notifications:
                        NotificationsSetupView(path: $path)
                            .navigationBarHidden(true)
                    case .choosePartner:
                        ChoosePartnerView(path: $path)
                            .navigationBarHidden(true)
                    }
                }
        }
        .tint(.accent)
        .environment(session)
    }
}
