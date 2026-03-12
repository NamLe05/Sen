import Foundation

nonisolated struct Block: Codable, Sendable, Identifiable, Equatable {
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
