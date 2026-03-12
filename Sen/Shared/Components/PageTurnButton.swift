import SwiftUI

struct PageTurnButton: View {
    let label: String
    var disabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.senTitle2)
                .foregroundColor(disabled ? .textDisabled : .textInverse)
                .tracking(0.3)
                .frame(width: 150)
                .padding(.top, Spacing.xxl)
                .padding(.bottom, 54)
                .background(disabled ? Color.textDisabled : Color.textPrimary)
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 24,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 0
                    )
                )
                .shadow(color: Color.textPrimary.opacity(0.1), radius: 12, x: -2, y: -4)
        }
        .disabled(disabled)
        .buttonStyle(PressOpacityStyle())
        .accessibilityLabel(label)
        .accessibilityAddTraits(.isButton)
    }
}

struct PressOpacityStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
