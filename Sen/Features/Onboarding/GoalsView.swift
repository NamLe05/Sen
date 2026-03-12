import SwiftUI

@MainActor
struct GoalsView: View {
    @Binding var path: NavigationPath
    @State private var selectedIndex: Int?

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

                VStack(alignment: .leading, spacing: Spacing.xl) {
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Text(OnboardingCopy.Goals.headline)
                            .font(.senLargeTitle)
                            .tracking(-0.5)
                            .foregroundColor(.textPrimary)

                        Text(OnboardingCopy.Goals.subhead)
                            .font(.senFootnote)
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.horizontal, Spacing.lg)
                    .fadeSlideIn(delay: 0.2)

                    VStack(spacing: Spacing.sm) {
                        ForEach(Array(OnboardingCopy.Goals.options.enumerated()), id: \.offset) { index, option in
                            goalOption(
                                icon: option.0,
                                title: option.1,
                                subtitle: option.2,
                                isSelected: selectedIndex == index
                            ) {
                                withAnimation(.easeOut(duration: 0.15)) {
                                    selectedIndex = index
                                }
                            }
                            .padding(.horizontal, Spacing.lg)
                            .fadeSlideIn(delay: 0.3 + Double(index) * 0.07)
                        }
                    }
                }
                .padding(.top, Spacing.lg)

                Spacer()
            }

            // Bottom left: page indicator
            VStack {
                Spacer()
                HStack {
                    PageIndicator(current: 2, total: 4)
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
                    PageTurnButton(
                        label: OnboardingCopy.Goals.next,
                        disabled: selectedIndex == nil
                    ) {
                        // TODO: Save goal preference to Convex user profile
                        path.append(OnboardingRoute.choosePartner)
                    }
                    .fadeSlideIn(delay: 0.55, fromBottom: true)
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgPrimary.ignoresSafeArea())
    }

    private func goalOption(
        icon: String,
        title: String,
        subtitle: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: Spacing.md) {
                Image(systemName: icon)
                    .font(.senTitle3)
                    .foregroundColor(isSelected ? .textInverse : .accent)
                    .frame(width: 44, height: 44)
                    .background(isSelected ? Color.accent : Color.bgSecondary)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.senHeadline)
                        .foregroundColor(isSelected ? .textInverse : .textPrimary)

                    Text(subtitle)
                        .font(.senCaption)
                        .foregroundColor(isSelected ? .textInverse.opacity(0.8) : .textSecondary)
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.senTitle3)
                    .foregroundColor(isSelected ? .textInverse : .textMuted)
            }
            .padding(Spacing.md)
            .background(isSelected ? Color.accent : Color.bgSecondary)
            .cornerRadius(Radius.md)
        }
        .buttonStyle(PressOpacityStyle())
        .accessibilityLabel(title)
    }
}
