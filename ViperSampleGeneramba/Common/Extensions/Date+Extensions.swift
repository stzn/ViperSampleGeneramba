import Foundation

private let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeZone = NSTimeZone.system
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.calendar = Calendar(identifier: .gregorian)
    return formatter
}()

extension Date {

    func string(format: String = DateFormat.defaultFormat) -> String {
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    init?(dateString: String, dateFormat: String = DateFormat.defaultFormat) {
        formatter.dateFormat = dateFormat
        guard let date = formatter.date(from: dateString) else { return nil }
        self = date
    }

    init?(fromISO8601: String) {
        guard let date = Date(dateString: fromISO8601, dateFormat: DateFormat.ISO8601Format) else { return nil }
        self = date
    }

    func adjustDays(days: Int = 0) -> Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: days, to: calendar.startOfDay(for: self))
    }
    
    static func minDate() -> Date {
        var components = DateComponents()
        components.year = -100
        return Calendar.current.date(byAdding: components, to: Date())!
    }
}

extension String {
    func toISO8601String(dateFormat: String) -> String? {
        guard let date = Date(dateString: self, dateFormat: dateFormat) else { return nil }
        return date.string(format: DateFormat.ISO8601Format)
    }

    func fromISO8601String(dateFormat: String) -> String? {
        guard let date = Date(fromISO8601: self) else { return nil }
        return date.string(format: dateFormat)
    }
    
    func convertDateFormat(from: String, to: String) -> String {
        
        guard let date = Date(dateString: self, dateFormat: from) else {
            return ""
        }
        return date.string(format: to)
    }
}
