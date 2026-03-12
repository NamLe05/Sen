import Foundation

// TODO: Single time block within a DayPlan — represents one scheduled activity

struct Block: Codable, Sendable, Identifiable, Equatable {
    let id: String
    let title: String
    let startTime: String
    let endTime: String
    let type: BlockType
    var checkedOff: Bool
    let photoStorageId: String?

    enum BlockType: String, Codable, Sendable {
        case task
        case meal
        case `class`
        case rest
    }
}
