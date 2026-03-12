import Foundation
import UserNotifications

// TODO: Requests notification permissions, registers APNs device token, stores token via ConvexService

@MainActor
@Observable
final class NotificationManager {
    var isAuthorized = false
    var deviceToken: String?
    var error: SenError?
}
