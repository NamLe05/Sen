import Foundation

nonisolated struct DayPlan: Codable, Sendable, Identifiable, Equatable {
    let id: String
    let userId: String
    let date: String
    let rawInput: String?
    var blocks: [Block]
    let generatedAt: Double

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId, date, rawInput, blocks, generatedAt
    }
}
