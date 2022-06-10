//
//  VideoQuality.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/9/22.
//

import Foundation

enum VideoQuality: String {
    case none
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var description: String {
        switch self {
        case .none: return "Select Video Quality"
        case .low: return "Low - 320p"
        case .medium: return "Medium - 720p"
        case .high: return "High - 1080p"
        }
    }
}
