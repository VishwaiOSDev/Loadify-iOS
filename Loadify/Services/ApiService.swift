//
//  ApiService.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/8/22.
//

import UIKit
import LoggerKit
import NetworkKit

class ApiService: FetchService {
    
    lazy var photoService: PhotosServiceProtocol = PhotosService()
    lazy var fileService: FileServiceProtocol = FileService()
    
    init() {
        Logger.initialize("ApiService Init - (\(Unmanaged.passUnretained(self).toOpaque()))")
    }
    
    func fetchVideoDetailsFromApi(for url: String) async throws -> VideoDetails {
        try await NetworkKit.shared.requestCodable(
            API.details(youtubeURL: url), type: VideoDetails.self
        )
    }
    
    deinit {
        Logger.teardown("ApiService Deinit - (\(Unmanaged.passUnretained(self).toOpaque()))")
    }
}

extension ApiService: DownloadService {
    
    func downloadVideo(for url: String, quality: VideoQuality) async throws {
        try await photoService.checkForPhotosPermission()
        let filePath = fileService.getTemporaryFilePath()
        let data = try await NetworkKit.shared.requestData(
            API.download(youtubeURL: url, quality: quality)
        )
        try data.write(to: filePath)
        try checkVideoIsCompatible(at: filePath.path)
        UISaveVideoAtPathToSavedPhotosAlbum(filePath.path, nil, nil, nil)
    }
    
    private func checkVideoIsCompatible(at filePath: String) throws {
        if !UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(filePath) {
            throw DownloadError.notCompatible
        }
    }
}
