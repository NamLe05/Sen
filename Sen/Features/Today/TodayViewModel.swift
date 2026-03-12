import Foundation
import Observation

// TODO: Fetches today's DayPlan from Convex, handles block check-off, drives lotus bloom state

@MainActor
@Observable
final class TodayViewModel {
    var dayPlan: DayPlan?
    var error: SenError?
}
