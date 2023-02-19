//
//  Logger+Extension.swift
//  Loadify
//
//  Created by Vishweshwaran on 19/02/23.
//

import Foundation
import NetworkKit
import LoggerKit

typealias Logger = LoadifyApp.Logger

extension LoadifyApp {
    
    struct Logger: Loggable {
        
        static var logTag: String { "Loadify" }
        static var logConfig: LoggerKit.LoggerConfig = .init(enable: true, severity: .info)
        
        static func configure() {
            NetworkKit.Logger.logConfig = .init(enable: false)
        }
    }
}
