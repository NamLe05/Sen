import Foundation

// TODO: Local representation of the Convex dayPlans table record

struct DayPlan: Codable, Sendable, Identifiable {
    let id: String
    let userId: String
    let date: String
    let rawInput: String?
    let blocks: [Block]
    let generatedAt: Double
}
