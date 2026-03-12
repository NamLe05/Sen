import SwiftUI

extension Color {
    // Brand
    static let accent         = Color(hex: "#5E72E4")   // periwinkle indigo
    static let accentLight    = Color(hex: "#8FA0F0")

    // Backgrounds
    static let bgPrimary      = Color(hex: "#FFFFFF")
    static let bgSecondary    = Color(hex: "#F5F5F7")   // surface / input bg
    static let bgTertiary     = Color(hex: "#EBEBF0")   // filled code box

    // Text
    static let textPrimary    = Color(hex: "#1A1A1A")
    static let textSecondary  = Color(hex: "#6B6B6B")
    static let textMuted      = Color(hex: "#9A9A9A")
    static let textDisabled   = Color(hex: "#C5C5C5")
    static let textInverse    = Color.white

    // Semantic
    static let border         = Color(hex: "#E5E7EB")
    static let senError       = Color(hex: "#DC2626")
    static let errorBg        = Color(hex: "#FEE2E2")
    static let success        = Color(hex: "#16A34A")

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red:   Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

enum Spacing {
    static let xs:  CGFloat = 4
    static let sm:  CGFloat = 8
    static let md:  CGFloat = 16
    static let lg:  CGFloat = 24
    static let xl:  CGFloat = 32
    static let xxl: CGFloat = 48
}

enum Radius {
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
}
