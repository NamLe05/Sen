import Foundation
import StoreKit

// TODO: Manages StoreKit 2 subscriptions — listens to Transaction.updates, verifies entitlements, syncs isPro to Convex

@MainActor
@Observable
final class StoreKitManager {
    var isPro = false
    var error: SenError?
}
