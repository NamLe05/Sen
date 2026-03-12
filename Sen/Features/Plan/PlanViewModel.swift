import Foundation
import Observation

// TODO: Manages voice/form input, sends audio to Convex → Gemini, receives generated blocks

@MainActor
@Observable
final class PlanViewModel {
    var isRecording = false
    var isGenerating = false
    var error: SenError?
}
