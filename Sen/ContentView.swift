import SwiftUI

struct ContentView: View {
    let convex: ConvexService
    @Environment(AuthManager.self) private var authManager
    @State private var isInitializing = true
    @State private var animationFinished = false
    @State private var authFinished = false

    var body: some View {
        ZStack {
            Color.accent.ignoresSafeArea()

            if !isInitializing {
                Group {
                    if authManager.isAuthenticated {
                        mainApp
                    } else {
                        OnboardingView()
                    }
                }
                .animation(.easeInOut(duration: 0.35), value: authManager.isAuthenticated)
                .transition(.opacity)
            }

            if isInitializing {
                loadingView
                    .transition(.opacity)
            }
        }
        .animation(.easeOut(duration: 0.6), value: isInitializing)
        .task {
            await authManager.restoreSession()
            authFinished = true
            if animationFinished { isInitializing = false }
        }
    }

    private var loadingView: some View {
        ZStack {
            Color.accent.ignoresSafeArea()

            VStack(spacing: 0) {
                LotusAnimationView(loopMode: .playOnce, speed: 1.0) {
                    animationFinished = true
                    if authFinished { isInitializing = false }
                }
                .frame(width: 320, height: 320)
                .colorInvert()
                .blendMode(.screen)

                HStack(spacing: 7) {
                    Image("sen_lotus_gradient")
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80)
                    Text("Sen")
                        .font(.senWordmarkDisplay)
                        .foregroundStyle(Color.textInverse)
                }
                .padding(.top, Spacing.lg)
            }
        }
    }

    private var mainApp: some View {
        TabView {
            TodayView(convex: convex)
                .tabItem { Label("Today", systemImage: "sun.max") }
            PlanView()
                .tabItem { Label("Plan", systemImage: "mic") }
            CalendarView()
                .tabItem { Label("Calendar", systemImage: "calendar") }
        }
        .transition(.opacity)
    }
}
