//
//  AlertOptions.swift
//  
//
//  Created by Vishweshwaran on 5/19/22.
//

import Foundation

public enum AlertStyle: String {
    case error = "xmark.octagon"
    case success = "checkmark.circle"
}

public struct AlertOptions {
    public var alertType: AlertStyle
    public var style: LoaderStyle
    
    public init(alertType: AlertStyle, style: LoaderStyle = .vertical) {
        self.alertType = alertType
        self.style = style
    }
}
