import SwiftUI

struct BlockRowView: View {
    let block: Block
    let isCurrent: Bool
    let onCheckOff: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onCheckOff) {
                Image(systemName: block.checkedOff ? "checkmark.circle.fill" : "circle")
                    .font(.senTitle2)
                    .foregroundStyle(block.checkedOff ? .green : .secondary)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 2) {
                Text(block.startTime)
                    .font(.senTimestamp)
                    .foregroundStyle(.secondary)
                Text(block.endTime)
                    .font(.senTimestamp2)
                    .foregroundStyle(.tertiary)
            }
            .frame(width: 44, alignment: .leading)

            VStack(alignment: .leading, spacing: 2) {
                Text(block.title)
                    .font(.senBody)
                    .strikethrough(block.checkedOff)
                    .foregroundStyle(block.checkedOff ? .secondary : .primary)

                Label(block.type.displayName, systemImage: block.type.iconName)
                    .font(.senCaption2)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(isCurrent ? Color.accentColor.opacity(0.08) : .clear)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .contentShape(Rectangle())
        .animation(.easeInOut(duration: 0.2), value: block.checkedOff)
    }
}

extension Block.BlockType {
    var iconName: String {
        switch self {
        case .task:    return "checklist"
        case .meal:    return "fork.knife"
        case .class:   return "book"
        case .rest:    return "moon.zzz"
        }
    }

    var displayName: String {
        switch self {
        case .task:    return "Task"
        case .meal:    return "Meal"
        case .class:   return "Class"
        case .rest:    return "Rest"
        }
    }
}
