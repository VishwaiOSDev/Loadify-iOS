//
//  Endpoint.swift
//  Loadify
//
//  Created by Vishweshwaran on 11/09/22.
//

import Foundation

@available(*, deprecated, message: "PlatformType is now deprecated. Use Platform from the LoadifyEngine instead.")
enum PlatformType: String {
    case youtube = "yt"
    case instagram = "ig" 
}

@available(*, deprecated, message: "API is deprecated. Use LoadifyClient from the LoadifyEngine instead")
enum API {
    case details(forPlatform: PlatformType, url: String)
    case download(url: String, quality: VideoQuality)
}

extension API: NetworkRequestable {
    
    var host: String {
        "loadify.madrasvalley.com"
    }
    
    var path: String {
        switch self {
        case .details(let platformType, _):
            return "/api/\(platformType.rawValue)/details"
        case .download:
            return "/api/yt/download/video/mp4"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .details, .download:
            return .get
        }
    }
    
    var queryParameters: [String : AnyHashable]? {
        switch self {
        case .details(_ , let url):
            return ["url": url]
        case .download(let url, let quality):
            return ["url": url, "video_quality": quality.rawValue]
        }
    }
    
    /// Configuration for `localhost`
    var shouldRunLocal: Bool { false }
    
    var port: Int? { 3200 }
}
