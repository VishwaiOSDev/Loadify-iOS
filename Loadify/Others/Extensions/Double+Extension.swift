//
//  Double+Extension.swift
//  Loadify
//
//  Created by Vishweshwaran on 12/06/22.
//

import Foundation

extension Double {
    
    /// ✅ Helper function for `toUnits` computed property
    func reduceScale(to places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        let newDecimal = multiplier * self
        let truncated = Double(Int(newDecimal))
        let originalDecimal = truncated / multiplier
        return originalDecimal
    }
}
