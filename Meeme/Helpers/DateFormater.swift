import Foundation

class DateFormatter {
    static func createTimestamp() -> Double {
        return NSDate().timeIntervalSince1970
    }

    static func getDateFromTimestamp(timestamp: Double) -> NSDate {
        let myTimeInterval: TimeInterval = TimeInterval(timestamp)
        return NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
    }
}
