//
//  AppConstants.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import Foundation

protocol Api {
    static var baseUrl: URL { get set }
}

enum Endpoint: Api {
    
    static var baseUrl: URL = URL(string: "https://api.tikapp.ml/api")!
    
    enum YouTube: String {
        case getDetails = "details"
        case downloadVideo = "/download/video"
        case downloadAudio = "/download/audio"
    }
}

