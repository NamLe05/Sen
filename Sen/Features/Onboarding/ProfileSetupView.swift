import SwiftUI

@MainActor
struct ProfileSetupView: View {
    @Binding var path: NavigationPath
    @State private var name = ""
    @FocusState private var focused: Bool

    private var canContinue: Bool { !name.trimmingCharacters(in: .whitespaces).isEmpty }

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
                    Text(OnboardingCopy.Profile.headline)
                        .font(.senLargeTitle)
                        .tracking(-0.5)
                        .foregroundColor(.textPrimary)
                        .padding(.horizontal, Spacing.lg)
                        .fadeSlideIn(delay: 0.2)

                    TextField(OnboardingCopy.Profile.placeholder, text: $name)
                        .font(.senInput)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                        .textContentType(.name)
                        .submitLabel(.done)
                        .focused($focused)
                        .onSubmit {
                            if canContinue { next() }
                        }
                        .padding(.horizontal, Spacing.lg)
                        .padding(.vertical, Spacing.md)
                        .background(Color.bgSecondary)
                        .cornerRadius(Radius.md)
                        .padding(.horizontal, Spacing.lg)
                        .fadeSlideIn(delay: 0.3)
                }
                .padding(.top, Spacing.lg)

                Spacer()
            }

            // Bottom left: page indicator
            VStack {
                Spacer()
                HStack {
                    PageIndicator(current: 1, total: 4)
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
                    PageTurnButton(label: OnboardingCopy.Profile.next, disabled: !canContinue) {
                        next()
                    }
                    .fadeSlideIn(delay: 0.4, fromBottom: true)
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgPrimary.ignoresSafeArea())
        .onAppear { focused = true }
    }

    private func next() {
        // TODO: Save name to Convex user profile
        path.append(OnboardingRoute.goals)
    }
}
