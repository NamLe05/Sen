import SwiftUI

struct PageIndicator: View {
    let current: Int
    let total: Int

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text("\(current)")
                .font(.senCounter)
                .foregroundColor(.textPrimary)
                .tracking(-0.5)
            Text("/\(total)")
                .font(.senTitle3)
                .foregroundColor(.textMuted)
        }
    }
}
