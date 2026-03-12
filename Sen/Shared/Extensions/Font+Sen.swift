import SwiftUI

// MARK: - Sen Type Scale
//
// Typeface: DM Sans (Google Fonts, v3+)
// Static files in Sen/Shared/Assets/Fonts/, registered in Info.plist UIAppFonts.
// PostScript names verified:
//   DMSans18pt-Thin, DMSans18pt-Regular, DMSans18pt-Medium, DMSans18pt-SemiBold,
//   DMSans18pt-Bold, DMSans18pt-Black

extension Font {

    // MARK: - Display

    /// 40pt Bold — hero screen headline (e.g. WelcomeView)
    static let senDisplay      = Font.custom("DMSans18pt-Bold",      size: 40)

    /// 36pt Bold — section / page headline
    static let senLargeTitle   = Font.custom("DMSans18pt-Bold",      size: 36)

    /// 36pt Black — large counter / page indicator number
    static let senCounter      = Font.custom("DMSans18pt-Black",     size: 36)

    /// 28pt Thin — splash wordmark ("sen") — original style, easy to revert
    static let senWordmark     = Font.custom("DMSans18pt-Thin",      size: 28)

    /// 28pt Bold — splash wordmark experiment
    static let senWordmarkBold = Font.custom("DMSans18pt-Bold",      size: 28)

    /// 36pt Bold — large centered splash wordmark
    static let senWordmarkDisplay = Font.custom("DMSans18pt-Bold",   size: 36)

    // MARK: - Titles

    /// 26pt SemiBold — prominent digit display (e.g. OTP boxes)
    static let senTitle        = Font.custom("DMSans18pt-SemiBold",  size: 26)

    /// 22pt Bold — page-turn button label, card titles
    static let senTitle2       = Font.custom("DMSans18pt-Bold",      size: 22)

    /// 22pt Medium — large text input field
    static let senInput        = Font.custom("DMSans18pt-Medium",    size: 22)

    /// 20pt SemiBold — sub-section titles, icon labels
    static let senTitle3       = Font.custom("DMSans18pt-SemiBold",  size: 20)

    // MARK: - Body

    /// 16pt SemiBold — button labels, back-button icons, form headlines
    static let senHeadline     = Font.custom("DMSans18pt-SemiBold",  size: 16)

    /// 16pt Regular — body copy, feature lists
    static let senBody         = Font.custom("DMSans18pt-Regular",   size: 16)

    /// 15pt SemiBold — secondary button labels (OAuth, etc.)
    static let senSubheadline  = Font.custom("DMSans18pt-SemiBold",  size: 15)

    /// 15pt Regular — descriptive subheadings, supporting text
    static let senFootnote     = Font.custom("DMSans18pt-Regular",   size: 15)

    // MARK: - Small

    /// 14pt Regular — small labels, skip/toggle text
    static let senLabel        = Font.custom("DMSans18pt-Regular",   size: 14)

    /// 14pt SemiBold — inline action links (sign-in / sign-up toggle)
    static let senLabelBold    = Font.custom("DMSans18pt-SemiBold",  size: 14)

    /// 13pt Regular — error messages, dividers, misc captions
    static let senCaption      = Font.custom("DMSans18pt-Regular",   size: 13)

    /// 13pt Medium — subtle interactive text (forgot password)
    static let senCaptionMedium = Font.custom("DMSans18pt-Medium",   size: 13)

    /// 13pt SemiBold — inline confirmations (code sent)
    static let senCaptionBold  = Font.custom("DMSans18pt-SemiBold",  size: 13)

    /// 12pt Regular — smallest labels, block type tags
    static let senCaption2     = Font.custom("DMSans18pt-Regular",   size: 12)

    /// 12pt Medium — legal / ToS text
    static let senLegal        = Font.custom("DMSans18pt-Medium",    size: 12)

    // MARK: - Monospaced (time display)

    /// 13pt Regular, monospaced digits — block start time
    static var senTimestamp:  Font { Font.custom("DMSans18pt-Regular", size: 13).monospacedDigit() }

    /// 12pt Regular, monospaced digits — block end time
    static var senTimestamp2: Font { Font.custom("DMSans18pt-Regular", size: 12).monospacedDigit() }

    // MARK: - SF Symbol sizes
    // Font family has no effect on SF Symbols; only the point size matters.

    /// 70pt — large decorative SF Symbol (e.g. leaf, bell on onboarding screens)
    static let senIconHero    = Font.system(size: 70)

    /// 34pt — mid-size SF Symbol (e.g. empty-state icons)
    static let senIconDisplay = Font.system(size: 34)

    /// 28pt — small decorative SF Symbol (e.g. sparkles in auth bar)
    static let senIconTitle   = Font.system(size: 28)
}
