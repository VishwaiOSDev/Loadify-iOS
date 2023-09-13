//
//  HUDComponents.swift
//  Loadify
//
//  Created by Vishweshwaran on 2023-09-12.
//

import SwiftUI

internal typealias Colors = HUDComponents.Colors

internal struct HUDComponents {
    
    struct Colors {
        static let green = Color("success_green", bundle: .module)
        static let gradient_green = Color("success_green_gradient", bundle: .module)
        static let red = Color("error_red", bundle: .module)
        static let red_gradient = Color("error_red_gradient", bundle: .module)
    }
}
