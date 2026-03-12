import SwiftUI

/// Reusable gradient lotus icon backed by the `sen_lotus` asset.
struct LotusIconView: View {
    var size: CGFloat = 180

    var body: some View {
        Image("sen_lotus_gradient")
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
    }
}
