import Foundation

nonisolated struct User: Codable, Sendable, Identifiable {
    let id: String
    let clerkId: String
    let name: String
    let apnsToken: String?
    let isPro: Bool
    let streak: Int
}
