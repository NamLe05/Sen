import SwiftUI

// TODO: Reusable row component for displaying a single Block — shows time, title, type icon, and check-off state

struct BlockRowView: View {
    let block: Block

    var body: some View {
        Text(block.title)
    }
}
