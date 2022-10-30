//
//  Int+Extension.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/22/22.
//

import Foundation

extension Optional where Wrapped == Int {
    
    /// ✅ To convert integer into short representation of numbers. For instance, **1500 will be converted to 1.5K**
    var toUnits: String {
        guard let self else { return "N/A" }
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""
        
        switch num {
        case 1_000_000_000...:
            var formatted = num / 1_000_000_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)B"
            
        case 1_000_000...:
            var formatted = num / 1_000_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)M"
            
        case 1_000...:
            var formatted = num / 1_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)K"
            
        case 0...:
            return "\(self)"
            
        default:
            return "\(sign)\(self)"
        }
    }
}
