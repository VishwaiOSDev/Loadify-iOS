//
//  ApiService.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/8/22.
//

import UIKit
import Combine
import LogKit
import Photos
import NetworkKit

class ApiService: FetchService {
    
    var downloadProgress = CurrentValueSubject<Double, Never>(0.0)
    
    var photoService: PhotosServiceProtocol
    var fileService: FileServiceProtocol
    
    private var anyCancellable: Set<AnyCancellable> = []
    
    init(
        photoService: PhotosServiceProtocol = PhotosService(),
        fileService: FileServiceProtocol = FileService()
    ) {
        self.photoService = photoService
        self.fileService = fileService
    }
    
    func fetchVideoDetailsFromApi(for url: String) async throws -> VideoDetails {
        try await NetworkKit
            .shared
            .requestCodable(API.details(youtubeURL: url), type: VideoDetails.self)
    }
    
    deinit {
        anyCancellable = []
    }
}

extension ApiService: DownloadService {
    func downloadVideo(for url: String, quality: VideoQuality) async throws {
        photoService.checkForPhotosPermission { permissionStatus in
            switch permissionStatus {
            case .success:
                self.downloadFromTheServer(url: url, quality: quality)
                break
            case .failure(let error):
                break
            }
        }
        
    }
    
    private func downloadFromTheServer(url: String, quality: VideoQuality) {
        let filePath = fileService.getTemporaryFilePath()
        NetworkKit.shared.requestData(API.download(youtubeURL: url, quality: quality)) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                do {
                    try data.write(to: filePath)
                    try self.checkVideoIsCompatible(at: filePath.path)
                    UISaveVideoAtPathToSavedPhotosAlbum(filePath.path, nil, nil, nil)
                } catch {
                    Log.error("Failed to save: \(error.localizedDescription)")
                }
            case .failure(let error):
                Log.error("Failed: \(error.localizedDescription)")
            }
        }
        trackDownloadProgress()
    }
    
    private func trackDownloadProgress() {
        NetworkKit.shared.downloadProgress
            .removeDuplicates()
            .sink(receiveCompletion: { [weak self] _ in
                guard let self else { return }
                self.downloadProgress.send(completion: .finished)
            }, receiveValue: { [weak self] progress in
                guard let self else { return }
                self.downloadProgress.send(progress)
            })
            .store(in: &anyCancellable)
    }
}
