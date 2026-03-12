import Foundation
import Observation

// TODO: Fetches past DayPlans from Convex, computes completion stats per day for calendar grid

@MainActor
@Observable
final class CalendarViewModel {
    var dayPlans: [DayPlan] = []
    var selectedDate: String?
    var error: SenError?
}
