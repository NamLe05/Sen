import SwiftUI

struct WelcomeView: View {
    @Binding var path: NavigationPath

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: Spacing.xl) {
                    Image("tasks_complete")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 260, height: 260)
                        .fadeSlideIn(delay: 0.2)

                    VStack(spacing: Spacing.sm) {
                        Text(OnboardingCopy.Welcome.headline)
                            .font(.senDisplay)
                            .tracking(-0.5)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.textPrimary)

                        Text(OnboardingCopy.Welcome.subhead)
                            .font(.senBody)
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: 280)
                    }
                    .fadeSlideIn(delay: 0.35)
                }

                Spacer()
            }

            // Bottom left: page indicator
            VStack {
                Spacer()
                HStack {
                    PageIndicator(current: 1, total: 2)
                        .padding(.leading, Spacing.xxl)
                        .padding(.bottom, Spacing.xl)
                        .fadeSlideIn(delay: 0.1)
                    Spacer()
                }
            }

            // Bottom right: next button (flush to corner)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    PageTurnButton(label: OnboardingCopy.Welcome.next) {
                        path.append(OnboardingRoute.info)
                    }
                    .fadeSlideIn(delay: 0.4, fromBottom: true)
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgPrimary.ignoresSafeArea())
    }
}
