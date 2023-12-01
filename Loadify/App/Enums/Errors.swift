//
//  Errors.swift
//  Loadify
//
//  Created by Vishweshwaran on 22/06/22.
//

import Foundation

enum DownloadError: Error, LocalizedError {
    
    case notCompatible
    
    var errorDescription: String? {
        switch self {
        case .notCompatible: 
            return "This video is not compatible to save"
        }
    }
}

enum PhotosError: Error, LocalizedError {
    
    case permissionDenied
    case insufficientStorage
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied: 
            return "Please grant permission to photos"
        case .insufficientStorage:
            return  "There is no enough storage to save this video"
        }
    }
}
