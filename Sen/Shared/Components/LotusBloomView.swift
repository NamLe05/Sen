import SwiftUI

struct LotusBloomView: View {
    let stage: BloomStage
    let fraction: Double

    private let petalCount = 8

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                // Water line
                Circle()
                    .stroke(Color.secondary.opacity(0.15), lineWidth: 1)
                    .frame(width: 140, height: 140)

                // Petals
                ForEach(0..<petalCount, id: \.self) { index in
                    PetalShape()
                        .fill(petalFill(for: index))
                        .frame(width: 28, height: 48)
                        .offset(y: -30)
                        .rotationEffect(.degrees(Double(index) * (360.0 / Double(petalCount))))
                        .scaleEffect(isPetalVisible(index) ? 1.0 : 0.01)
                        .opacity(isPetalVisible(index) ? 1.0 : 0.0)
                }
                .animation(.spring(response: 0.6, dampingFraction: 0.7), value: stage)

                // Center
                Circle()
                    .fill(centerColor)
                    .frame(width: 36, height: 36)

                Text("\(Int(fraction * 100))")
                    .font(.senCaptionBold)
                    .foregroundStyle(.primary)
            }
            .frame(width: 140, height: 140)

            Text(stage.label)
                .font(.senCaption2)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Private

    private func isPetalVisible(_ index: Int) -> Bool {
        let visibleCount: Int
        switch stage {
        case .seed:       visibleCount = 0
        case .sprout:     visibleCount = 1
        case .bud:        visibleCount = 3
        case .halfBloom:  visibleCount = 5
        case .fullBloom:  visibleCount = 7
        case .lotus:      visibleCount = petalCount
        }
        return index < visibleCount
    }

    private func petalFill(for index: Int) -> Color {
        isPetalVisible(index) ? .primary.opacity(0.7) : .clear
    }

    private var centerColor: Color {
        switch stage {
        case .seed:                      return .secondary.opacity(0.2)
        case .sprout, .bud:              return .secondary.opacity(0.3)
        case .halfBloom, .fullBloom:     return .secondary.opacity(0.4)
        case .lotus:                     return .primary.opacity(0.15)
        }
    }
}

extension BloomStage {
    var label: String {
        switch self {
        case .seed:       return "Plant your day"
        case .sprout:     return "Sprouting"
        case .bud:        return "Budding"
        case .halfBloom:  return "Blooming"
        case .fullBloom:  return "Almost there"
        case .lotus:      return "Full bloom"
        }
    }
}

// MARK: - Petal Shape

private struct PetalShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height

        path.move(to: CGPoint(x: width / 2, y: 0))
        path.addQuadCurve(
            to: CGPoint(x: width / 2, y: height),
            control: CGPoint(x: width * 1.1, y: height * 0.5)
        )
        path.addQuadCurve(
            to: CGPoint(x: width / 2, y: 0),
            control: CGPoint(x: -width * 0.1, y: height * 0.5)
        )
        return path
    }
}
