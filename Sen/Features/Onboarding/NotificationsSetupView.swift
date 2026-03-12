import SwiftUI

@MainActor
struct NotificationsSetupView: View {
    @Binding var path: NavigationPath
    @Environment(AuthManager.self) private var authManager
    @Environment(OnboardingSession.self) private var session

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Top bar: back button
                HStack {
                    Button {
                        path.removeLast()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.senHeadline)
                            .foregroundColor(.textInverse)
                            .frame(width: 44, height: 44)
                            .background(Color.textPrimary)
                            .clipShape(Circle())
                    }
                    .accessibilityLabel("Go back")
                    Spacer()
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.top, Spacing.md)
                .fadeSlideIn(delay: 0)

                Spacer()

                VStack(spacing: Spacing.xxl) {
                    VStack(spacing: Spacing.lg) {
                        Image(systemName: "bell.badge.fill")
                            .font(.senIconHero)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.accent, .accentLight],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .fadeSlideIn(delay: 0.2)

                        VStack(spacing: Spacing.sm) {
                            Text(OnboardingCopy.Notifications.headline)
                                .font(.senLargeTitle)
                                .tracking(-0.5)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.textPrimary)

                            Text(OnboardingCopy.Notifications.subhead)
                                .font(.senFootnote)
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: 280)
                        }
                        .fadeSlideIn(delay: 0.3)
                    }

                    VStack(spacing: Spacing.sm) {
                        Button {
                            Task {
                                await enableNotifications()
                                await finishOnboarding()
                            }
                        } label: {
                            Text(OnboardingCopy.Notifications.enable)
                                .font(.senHeadline)
                                .foregroundColor(.textInverse)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(Color.accent)
                                .cornerRadius(Radius.md)
                        }
                        .buttonStyle(PressOpacityStyle())
                        .padding(.horizontal, Spacing.lg)

                        Button(OnboardingCopy.Notifications.skip) {
                            Task { await finishOnboarding() }
                        }
                        .font(.senLabel)
                        .foregroundColor(.textMuted)
                    }
                    .fadeSlideIn(delay: 0.4)
                }
                .frame(maxWidth: .infinity)

                Spacer()
            }

            // Bottom left: page indicator
            VStack {
                Spacer()
                HStack {
                    PageIndicator(current: 4, total: 4)
                        .padding(.leading, Spacing.xxl)
                        .padding(.bottom, Spacing.xl)
                        .fadeSlideIn(delay: 0.1)
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgPrimary.ignoresSafeArea())
    }

    private func enableNotifications() async {
        // TODO: Request notification permission via NotificationManager
        // await notificationManager.requestAuthorization()
    }

    private func finishOnboarding() async {
        await authManager.signIn(token: session.pendingToken, clerkId: session.pendingClerkId)
    }
}
