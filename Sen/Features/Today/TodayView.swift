import SwiftUI

struct TodayView: View {
    @State private var viewModel: TodayViewModel

    init(convex: ConvexService) {
        #if DEBUG
        _viewModel = State(initialValue: TodayViewModel(convex: convex, useMockData: true))
        #else
        _viewModel = State(initialValue: TodayViewModel(convex: convex))
        #endif
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection

                    LotusBloomView(
                        stage: viewModel.bloomStage,
                        fraction: viewModel.completionFraction
                    )
                    .padding(.vertical, 8)

                    if let plan = viewModel.dayPlan {
                        blocksSection(plan: plan)
                    } else if viewModel.isLoading {
                        ProgressView()
                            .padding(.top, 40)
                    } else {
                        emptyState
                    }
                }
                .padding()
            }
            .navigationTitle("Today")
            .toolbar {
                #if DEBUG
                ToolbarItem(placement: .topBarTrailing) {
                    SignOutButton()
                }
                #endif
            }
            .task {
                await viewModel.startPolling()
            }
            .alert(
                "Error",
                isPresented: Binding(
                    get: { viewModel.error != nil },
                    set: { if !$0 { viewModel.error = nil } }
                )
            ) {
                Button("OK", role: .cancel) {}
            } message: {
                if let error = viewModel.error {
                    Text(errorMessage(error))
                }
            }
        }
    }

    // MARK: - Sections

    private var headerSection: some View {
        Text(Date().formatted(.dateTime.weekday(.wide).month().day()))
            .font(.senTitle3)
            .foregroundStyle(.secondary)
    }

    @ViewBuilder
    private func blocksSection(plan: DayPlan) -> some View {
        LazyVStack(spacing: 4) {
            ForEach(plan.blocks) { block in
                BlockRowView(
                    block: block,
                    isCurrent: block.id == viewModel.currentBlockId,
                    onCheckOff: {
                        Task { [weak viewModel] in
                            await viewModel?.checkOff(blockId: block.id)
                        }
                    }
                )
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "sun.max")
                .font(.senIconDisplay)
                .foregroundStyle(.tertiary)
            Text("No plan for today")
                .font(.senHeadline)
            Text("Tap Plan to create your day")
                .font(.senFootnote)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 40)
    }

    // MARK: - Helpers

    private func errorMessage(_ error: SenError) -> String {
        switch error {
        case .network(let msg): return msg
        case .auth(let msg): return msg
        case .unknown(let msg): return msg
        }
    }
}
