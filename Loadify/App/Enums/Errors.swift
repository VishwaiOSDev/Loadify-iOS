//
//  Errors.swift
//  Loadify
//
//  Created by Vishweshwaran on 22/06/22.
//

import Foundation

enum ServerError: Error, LocalizedError {
    case notValidDomain
    case internalServerError
    case requestedQualityUnavailable
    case durationTooHigh
    case decodeFailed
    
    var errorDescription: String? {
        switch self {
        case .notValidDomain: return "Error: Not a YouTube domain"
        case .internalServerError: return "Something went wrong"
        case .requestedQualityUnavailable: return "The requested quality is not supported"
        case .durationTooHigh: return "Requested video length is too high"
        case .decodeFailed: return "Failed to decode data"
        }
    }
}

enum DetailsError: Error, LocalizedError {
    case emptyUrl
    case invaildApiUrl
    case notVaildYouTubeUrl
    
    var errorDescription: String? {
        switch self {
        case .emptyUrl: return "URL cannot be empty"
        case .invaildApiUrl: return "This is not valid Url"
        case .notVaildYouTubeUrl: return "This is not a valid YouTube Url"
        }
    }
}

enum DownloadError: Error, LocalizedError {
    case notCompatible
    case fatalError
    case qualityNotAvailable
    case durationTooHigh
    
    var errorDescription: String? {
        switch self {
        case .notCompatible: return "This video is not compatible to save"
        case .fatalError: return "Something went worng. Please try again later"
        case .qualityNotAvailable: return "The request quality is not available"
        case .durationTooHigh: return "Duration is greater than 15 minutes"
        }
    }
}

enum PhotosError: Error, LocalizedError {
    case permissionDenied
    case insufficientStorage
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied: return "Please grant permission to photos"
        case .insufficientStorage: return  "There is no enough storage to save this video"
        }
    }
}

