import SwiftUI

struct InfoView: View {
    @Binding var path: NavigationPath

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Top bar: back button — same positioning as all other screens
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

                // Cap top spacer so content sits in upper half
                Spacer().frame(maxHeight: Spacing.xxl)

                // Mirror WelcomeView: VStack(spacing: .xl) between image and text
                VStack(spacing: Spacing.xxl) {
                    ZStack {
                        Image("hotair_balloon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 260, height: 260)
                            .frame(maxWidth: .infinity)
                            .offset(y: -Spacing.sm)
                            .fadeSlideIn(delay: 0.2)

                        Image("clouds")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150)
                            .offset(x: -(Spacing.xxl + Spacing.lg), y: (2 * Spacing.xxl + Spacing.xl))
                            .fadeSlideIn(delay: 0.25)
                    }
                    .frame(height: 260)

                    VStack(spacing: Spacing.lg) {
                        Text(OnboardingCopy.Info.headline)
                            .font(.senDisplay)
                            .tracking(-0.5)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.textPrimary)
                            .fadeSlideIn(delay: 0.3)

                        VStack(alignment: .leading, spacing: Spacing.md) {
                            ForEach(Array(OnboardingCopy.Info.features.enumerated()), id: \.offset) { index, feature in
                                HStack(alignment: .center, spacing: Spacing.sm) {
                                    Image(systemName: feature.0)
                                        .font(.senLabelBold)
                                        .foregroundColor(.accent)
                                        .frame(width: 20)

                                    Text(feature.1)
                                        .font(.senBody)
                                        .foregroundColor(.textSecondary)
                                }
                                .fadeSlideIn(delay: 0.35 + Double(index) * 0.07)
                            }
                        }
                        .frame(maxWidth: 300)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .fadeSlideIn(delay: 0.3)
                    .padding(.horizontal, Spacing.xl)
                }

                Spacer()
            }

            // Bottom left: page indicator
            VStack {
                Spacer()
                HStack {
                    PageIndicator(current: 2, total: 2)
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
                    PageTurnButton(label: OnboardingCopy.Info.next) {
                        path.append(OnboardingRoute.auth)
                    }
                    .fadeSlideIn(delay: 0.45, fromBottom: true)
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgPrimary.ignoresSafeArea())
    }
}
