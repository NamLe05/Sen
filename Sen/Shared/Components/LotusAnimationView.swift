import SwiftUI
import Lottie

struct LotusAnimationView: UIViewRepresentable {
    enum LoopMode {
        case playOnce
        case loop

        fileprivate var lottie: LottieLoopMode {
            switch self {
            case .playOnce: return .playOnce
            case .loop:     return .loop
            }
        }
    }

    var loopMode: LoopMode = .playOnce
    var speed: CGFloat = 1.0
    var onComplete: (() -> Void)? = nil

    func makeUIView(context: Context) -> LottieAnimationView {
        let view = LottieAnimationView(name: "Lotus", bundle: .main)
        view.loopMode = loopMode.lottie
        view.animationSpeed = speed
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .clear
        view.clipsToBounds = true
        // Allow SwiftUI .frame() to control size rather than intrinsic content size
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentHuggingPriority(.defaultLow, for: .vertical)

        if let onComplete {
            view.play { finished in
                guard finished else { return }
                Task { @MainActor in onComplete() }
            }
        } else {
            view.play()
        }

        return view
    }

    func updateUIView(_ uiView: LottieAnimationView, context: Context) {}
}
