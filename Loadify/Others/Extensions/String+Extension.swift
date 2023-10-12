//
//  String+Extension.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/22/22.
//

import Foundation

internal enum NeededComponent {
    case year
    case month
    case date
}

internal enum Month: Int {
    case january = 1, february, march, april, may, june, july, august, september, october, november, december
}

extension String {
    
    /// ✅ To add commas in between the numbers
    var format: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let number = Int(self) else { return "Hidden" }
        guard let formattedNumber = numberFormatter.string(from: NSNumber(value: number)) else {
            return "Hidden"
        }
        return formattedNumber
    }
    
    /// ✅ To convert the length in seconds to duration of the view.
    var getDuration: String {
        guard let interval = Int(self) else { return "Duration Unavailable" }
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: TimeInterval(interval))!.replacingOccurrences(of: #"^00[:.]0?|^0"#, with: "", options: .regularExpression)
    }
    
    /// ✅ To convert the date string into formatted date. For example, 2000-01-01 will be converted to 1 Jan 2000
    func formattedDate(_ component: NeededComponent? = nil) -> String {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [
            .withFullDate,
            .withDashSeparatorInDate,
            .withTime,
            .withColonSeparatorInTime,
            .withTimeZone
        ]
        
        guard let date = isoDateFormatter.date(from: self) else {
            return "N/A"
        }
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        
        switch component {
        case .year:
            return String(dateComponents.year ?? 0)
        case .month:
            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "MMMM"
            return monthFormatter.string(from: date)
        case .date:
            return String(dateComponents.day ?? 0)
        default:
            let day = dateComponents.day ?? 0
            let month = Month(rawValue: dateComponents.month ?? 0) ?? .january
            return "\(day) \(getMonthNotation(for: month))"
        }
    }
        
    func checkIsEmpty() -> Bool {
        let text = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return text.isEmpty ? true : false
    }
    
    /// Helper function for combined the date and month in String
    private func combineDateAndMonth(date: Int, month: Month) -> String {
        let convertedMonth = getMonthNotation(for: month)
        return "\(date) \(convertedMonth)"
    }
    
    /// Helper function to get String representation of month
    private func getMonthNotation(for month: Month) -> String {
        switch month {
        case .january: return "Jan"
        case .february: return "Feb"
        case .march: return "Mar"
        case .april: return "Apr"
        case .may: return "May"
        case .june: return "Jun"
        case .july: return "Jul"
        case .august: return "Aug"
        case .september: return "Sep"
        case .october: return "Oct"
        case .november: return "Nov"
        case .december: return "Dec"
        }
    }
}
