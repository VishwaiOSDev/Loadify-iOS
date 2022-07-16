//
//  AppConstants.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import Foundation

enum Api {
    
    enum URLType {
        case preAlpha, live
    }
    
    static func getBaseUrl(_ urlType: URLType) -> String {
        switch urlType {
        case .preAlpha:
            return "https://pre-alpha.loadify.app/api"
        case .live:
            return "https://api.loadify.app/api"
        }
    }
    
    enum Web: String {
        case termsOfService = "https://loadify.app/pages/TermsOfService.html"
        case privacyPolicy = "https://loadify.app/pages/PrivacyPolicy.html"
    }
    
    enum YouTube: String {
        case getDetails = "/yt/details?url="
        case videoQuality = "&video_quality="
        case downloadVideo = "/yt/download/video/mp4?url="
        case downloadAudio = "/yt/download/audio/mp3?url="
    }
    
    enum Twitter: String {
        case getDetails = "/tw/details?url="
        case videoQuality = "&video_quality="
        case downloadVideo = "/tw/download/video/mp4?url="
        case downloadAudio = "/tw/download/audio/mp3?url="
    }
    
    enum Facebook: String {
        case getDetails = "/fb/details?url="
        case videoQuality = "&video_quality="
        case downloadVideo = "/fb/download/video/mp4?url="
        case downloadAudio = "/fb/download/audio/mp3?url="
    }
    
    enum LinkedIn: String {
        case getDetails = "/ln/details?url="
        case videoQuality = "&video_quality="
        case downloadVideo = "/ln/download/video/mp4?url="
        case downloadAudio = "/ln/download/audio/mp3?url="
    }
}

