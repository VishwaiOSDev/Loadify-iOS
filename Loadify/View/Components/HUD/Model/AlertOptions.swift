//
//  AlertOptions.swift
//  
//
//  Created by Vishweshwaran on 5/19/22.
//

import Foundation

enum AlertStyle: String {
    case error = "xmark.octagon"
    case success = "checkmark.circle"
}

struct AlertOptions {
    
    var alertType: AlertStyle
    var style: LoaderStyle
    
    init(alertType: AlertStyle, style: LoaderStyle = .vertical) {
        self.alertType = alertType
        self.style = style
    }
}
