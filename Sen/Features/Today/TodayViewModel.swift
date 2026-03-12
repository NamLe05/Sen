import Foundation
import Observation
import OSLog

nonisolated enum BloomStage: Sendable {
    case seed
    case sprout
    case bud
    case halfBloom
    case fullBloom
    case lotus
}

@MainActor
@Observable
final class TodayViewModel {
    var dayPlan: DayPlan?
    var error: SenError?
    var isLoading = false

    private let convex: ConvexService
    private let logger = Logger(subsystem: "com.sen.app", category: "TodayVM")

    #if DEBUG
    var useMockData = false

    init(convex: ConvexService, useMockData: Bool = false) {
        self.convex = convex
        self.useMockData = useMockData
    }
    #else
    init(convex: ConvexService) {
        self.convex = convex
    }
    #endif

    // MARK: - Computed

    var completionFraction: Double {
        guard let blocks = dayPlan?.blocks, !blocks.isEmpty else { return 0 }
        let checked = blocks.filter(\.checkedOff).count
        return Double(checked) / Double(blocks.count)
    }

    var bloomStage: BloomStage {
        let pct = completionFraction
        switch pct {
        case 0:            return .seed
        case ..<0.26:      return .sprout
        case ..<0.51:      return .bud
        case ..<0.76:      return .halfBloom
        case ..<1.0:       return .fullBloom
        default:           return .lotus
        }
    }

    var currentBlockId: String? {
        guard let blocks = dayPlan?.blocks else { return nil }
        let now = Date()
        return blocks.first { block in
            guard let start = Date.fromTimeString(block.startTime),
                  let end = Date.fromTimeString(block.endTime) else { return false }
            return now >= start && now < end
        }?.id
    }

    // MARK: - Data Loading

    func startPolling() async {
        isLoading = dayPlan == nil

        #if DEBUG
        if useMockData {
            dayPlan = Self.mockDayPlan
            isLoading = false
            return
        }
        #endif

        while !Task.isCancelled {
            await fetchTodayPlan()
            if isLoading { isLoading = false }
            try? await Task.sleep(for: .seconds(5))
        }
    }

    // MARK: - Check-Off

    func checkOff(blockId: String) async {
        guard var plan = dayPlan,
              let index = plan.blocks.firstIndex(where: { $0.id == blockId })
        else { return }

        let previousState = plan.blocks[index].checkedOff
        let newState = !previousState

        // Optimistic update
        plan.blocks[index].checkedOff = newState
        dayPlan = plan

        do {
            try await convex.mutation(
                path: "dayPlans:checkOffBlock",
                args: [
                    "planId": .string(plan.id),
                    "blockId": .string(blockId),
                    "checkedOff": .bool(newState)
                ]
            )
        } catch {
            // Revert on failure
            if var revertPlan = dayPlan,
               let idx = revertPlan.blocks.firstIndex(where: { $0.id == blockId }) {
                revertPlan.blocks[idx].checkedOff = previousState
                dayPlan = revertPlan
            }
            self.error = .network("Failed to update block")
            logger.error("Check-off failed: \(error.localizedDescription)")
        }
    }

    // MARK: - Private

    #if DEBUG
    private static let mockDayPlan = DayPlan(
        id: "mock_plan_1",
        userId: "mock_user",
        date: Date.todayISO,
        rawInput: "Gym, leetcode, class at 2:30, dinner",
        blocks: [
            Block(id: "1", title: "Morning Routine", startTime: "07:00", endTime: "07:30", type: .task, checkedOff: true, photoStorageId: nil),
            Block(id: "2", title: "Gym", startTime: "07:30", endTime: "09:00", type: .task, checkedOff: true, photoStorageId: nil),
            Block(id: "3", title: "LeetCode Practice", startTime: "09:30", endTime: "11:00", type: .task, checkedOff: false, photoStorageId: nil),
            Block(id: "4", title: "Lunch", startTime: "12:00", endTime: "13:00", type: .meal, checkedOff: false, photoStorageId: nil),
            Block(id: "5", title: "Data Structures", startTime: "14:30", endTime: "16:00", type: .class, checkedOff: false, photoStorageId: nil),
            Block(id: "6", title: "Homework", startTime: "16:30", endTime: "18:00", type: .task, checkedOff: false, photoStorageId: nil),
            Block(id: "7", title: "Dinner", startTime: "18:30", endTime: "19:30", type: .meal, checkedOff: false, photoStorageId: nil),
            Block(id: "8", title: "Rest", startTime: "21:00", endTime: "22:00", type: .rest, checkedOff: false, photoStorageId: nil),
        ],
        generatedAt: Date().timeIntervalSince1970 * 1000
    )
    #endif

    private func fetchTodayPlan() async {
        do {
            let plan: DayPlan? = try await convex.queryOptional(
                path: "dayPlans:getTodayPlan",
                args: ["date": .string(Date.todayISO)]
            )
            if plan != dayPlan {
                dayPlan = plan
            }
        } catch {
            if self.error == nil {
                self.error = .network("Failed to load today's plan")
            }
            logger.error("Fetch failed: \(error.localizedDescription)")
        }
    }
}
