//
//  PhotosService.swift
//  Loadify
//
//  Created by Vishweshwaran on 09/06/22.
//

import Photos

protocol PhotosServiceProtocol {
    func checkForPhotosPermission() async throws
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

class PhotosService: PhotosServiceProtocol {
    
    func checkForPhotosPermission() async throws {
        switch PHPhotoLibrary.authorizationStatus(for: .addOnly) {
        case .notDetermined:
            try await requestPermissionForPhotos()
        case .authorized, .limited:
            break
        default:
            throw PhotosError.permissionDenied
        }
    }
    
    private func requestPermissionForPhotos() async throws {
        switch await PHPhotoLibrary.requestAuthorization(for: .addOnly) {
        case .authorized, .limited:
            break
        default:
            throw PhotosError.permissionDenied
        }
    }
}

