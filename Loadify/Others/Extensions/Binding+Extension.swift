//
//  Binding+Extension.swift
//  Loadify
//
//  Created by Vishweshwaran on 13/06/22.
//

import SwiftUI

extension Binding where Value == Bool {
    var invert: Binding<Value> {
        Binding<Value>(
            get: { !self.wrappedValue },
            set: { self.wrappedValue = !$0 }
        )
    }
}
