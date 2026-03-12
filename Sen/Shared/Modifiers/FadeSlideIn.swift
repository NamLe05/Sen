import SwiftUI

struct FadeSlideIn: ViewModifier {
    let delay: Double
    let fromBottom: Bool
    @State private var appeared = false

    func body(content: Content) -> some View {
        content
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : (fromBottom ? 30 : -20))
            .animation(.easeOut(duration: 0.5).delay(delay), value: appeared)
            .onAppear { appeared = true }
    }
}

extension View {
    func fadeSlideIn(delay: Double = 0, fromBottom: Bool = false) -> some View {
        modifier(FadeSlideIn(delay: delay, fromBottom: fromBottom))
    }
}
