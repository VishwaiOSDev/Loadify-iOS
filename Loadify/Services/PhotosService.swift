//
//  PhotosService.swift
//  Loadify
//
//  Created by Vishweshwaran on 09/06/22.
//

import Photos

protocol PhotosServiceProtocol {
    func checkForPhotosPermission() async throws
    func checkForPhotosPermission(completion: @escaping (Result<Void, Error>) -> Void)
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
    
    func checkForPhotosPermission(completion: @escaping (Result<Void, Error>) -> Void) {
        switch PHPhotoLibrary.authorizationStatus(for: .addOnly) {
        case .notDetermined:
            requestPermissionForPhotos { result in
                switch result {
                case .success:
                    break
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        case .authorized, .limited:
            completion(.success(()))
        default:
            completion(.failure(PhotosError.permissionDenied))
        }
    }
}

extension PhotosService {
    
    fileprivate func requestPermissionForPhotos(completion: @escaping (Result<Void, Error>) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            switch status {
            case .authorized, .limited:
                completion(.success(()))
            default:
                completion(.failure(PhotosError.permissionDenied))
            }
        }
    }
    
    fileprivate func requestPermissionForPhotos() async throws {
        switch await PHPhotoLibrary.requestAuthorization(for: .addOnly) {
        case .authorized, .limited:
            break
        default:
            throw PhotosError.permissionDenied
        }
    }
}

