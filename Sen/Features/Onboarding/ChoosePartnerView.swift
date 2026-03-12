import SwiftUI

@MainActor
struct ChoosePartnerView: View {
    @Binding var path: NavigationPath
    @State private var selectedIndex: Int?

    private let outerCircleSize: CGFloat = 180
    private let imageSize: CGFloat = 145
    private let strokeWidth: CGFloat = 6

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

                // Title — centered, consistent font with other onboarding screens
                Text(OnboardingCopy.ChoosePartner.headline)
                    .font(.senLargeTitle)
                    .tracking(-0.5)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, Spacing.lg)
                    .padding(.top, Spacing.lg)
                    .fadeSlideIn(delay: 0.2)

                // Partner circles — slightly above center
                Spacer()

                HStack(spacing: Spacing.xl) {
                    partnerCircle(index: 0)
                        .fadeSlideIn(delay: 0.35)
                    partnerCircle(index: 1)
                        .fadeSlideIn(delay: 0.45)
                }
                .offset(y: -Spacing.xxl)

                Spacer()
                Spacer()
            }

            // Bottom left: page indicator
            VStack {
                Spacer()
                HStack {
                    PageIndicator(current: 3, total: 4)
                        .padding(.leading, Spacing.xxl)
                        .padding(.bottom, Spacing.xl)
                        .fadeSlideIn(delay: 0.1)
                    Spacer()
                }
            }

            // Bottom right: next button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    PageTurnButton(
                        label: OnboardingCopy.ChoosePartner.next,
                        disabled: selectedIndex == nil
                    ) {
                        path.append(OnboardingRoute.notifications)
                    }
                    .fadeSlideIn(delay: 0.55, fromBottom: true)
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgPrimary.ignoresSafeArea())
    }

    private func partnerCircle(index: Int) -> some View {
        let isSelected = selectedIndex == index
        return Button {
            withAnimation(.easeOut(duration: 0.15)) {
                selectedIndex = index
            }
        } label: {
            ZStack {
                Circle()
                    .stroke(
                        isSelected ? Color.accent : Color.textPrimary,
                        lineWidth: strokeWidth
                    )
                    .frame(width: outerCircleSize, height: outerCircleSize)

                Image("sen_boy_face")
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageSize, height: imageSize)
                    .clipShape(Circle())
            }
            .frame(width: outerCircleSize, height: outerCircleSize)
        }
        .buttonStyle(PressOpacityStyle())
        .accessibilityLabel("Partner option \(index + 1)")
    }

}
