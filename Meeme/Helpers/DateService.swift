import Foundation

class DateService {
    static func createTimestamp() -> Double {
        return NSDate().timeIntervalSince1970
    }

    static func getDateFromTimestamp(timestamp: Double) -> NSDate {
        let myTimeInterval = TimeInterval(timestamp)
        return NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
    }
}
