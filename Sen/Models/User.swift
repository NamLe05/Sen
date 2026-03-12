import Foundation

// TODO: Local representation of the Convex users table record

struct User: Codable, Sendable, Identifiable {
    let id: String
    let clerkId: String
    let name: String
    let apnsToken: String?
    let isPro: Bool
    let streak: Int
}
