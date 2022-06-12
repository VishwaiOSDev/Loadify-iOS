//
//  String+Extension.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/22/22.
//

import Foundation

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
    
    func dateFormatter(get: String? = nil) -> String {
        let splittedDate = self.split(separator: "-")
        guard get != nil else {
            return extractDateAlgorithim(for: splittedDate)
        }
        return String(splittedDate[0])
    }
    
    func checkIsEmpty() -> Bool {
        let text = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return text.isEmpty ? true : false
    }
    
    private func extractDateAlgorithim(for splittedDate: [String.SubSequence]) -> String {
        let month = getMonth(for: String(splittedDate[1]))
        let day = Int(splittedDate[2])!
        let dayString = String(day)
        let date = String("\(dayString) " + "\(month) ")
        return date
    }
    
    private func getMonth(for month: String) -> String {
        switch month {
        case "01":
            return "Jan"
        case "02":
            return "Feb"
        case "03":
            return "Mar"
        case "04":
            return "Apr"
        case "05":
            return "May"
        case "06":
            return "Jun"
        case "07":
            return "July"
        case "08":
            return "Aug"
        case "09":
            return "Sep"
        case "10":
            return "Oct"
        case "11":
            return "Nov"
        case "12":
            return "Dec"
        default:
            return "Not mentioned"
        }
    }
}
