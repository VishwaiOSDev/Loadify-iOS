//
//  AppConstants.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import Foundation

enum AppConstants {
    enum Api {
        static let apiUrl: String = "https://api.tikapp.ml/api"
        
        enum QueryKey: String {
            case url = "url"
            case videoQuality = "video_quality"
        }
    }
}
