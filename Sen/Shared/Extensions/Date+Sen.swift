import Foundation

extension Date {
    private static let isoDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        return formatter
    }()

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        return formatter
    }()

    var isoDateString: String {
        Self.isoDateFormatter.string(from: self)
    }

    static var todayISO: String {
        Date().isoDateString
    }

    var timeString: String {
        Self.timeFormatter.string(from: self)
    }

    static func fromTimeString(_ time: String, on date: Date = Date()) -> Date? {
        let combined = "\(date.isoDateString) \(time)"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        return formatter.date(from: combined)
    }
}
