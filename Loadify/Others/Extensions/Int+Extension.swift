//
//  Int+Extension.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/22/22.
//

import Foundation

extension Int {
    var shortStringRepresentation: String {
        let number = Double(self)
        if number.isNaN {
            return "NaN"
        }
        if number.isInfinite {
            return "\(number < 0.0 ? "-" : "+")Infinity"
        }
        let units = ["", "k", "M"]
        var interval = number
        var i = 0
        while i < units.count - 1 {
            if abs(interval) < 1000.0 {
                break
            }
            i += 1
            interval /= 1000.0
        }
        // + 2 to have one digit after the comma, + 1 to not have any.
        // Remove the * and the number of digits argument to display all the digits after the comma.
        return "\(String(format: "%0.*g", Int(log10(abs(interval))) + 1, interval))\(units[i])"
    }
}
