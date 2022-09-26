//
//  ApiService.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/8/22.
//

import UIKit
import LogKit
import Photos
import NetworkKit

class ApiService: FetchService, DownloadService {
    
    var photoService: PhotosServiceProtocol
    var fileService: FileServiceProtocol
    
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
    
    func downloadVideo(for url: String, quality: VideoQuality) async throws {
        try await photoService.checkForPhotosPermission()
        let filePath = fileService.getTemporaryFilePath()
        let data = try await NetworkKit
            .shared
            .requestData(API.download(youtubeURL: url, quality: quality))
        try data.write(to: filePath)
        try checkVideoIsCompatible(at: filePath.path)
        UISaveVideoAtPathToSavedPhotosAlbum(filePath.path, nil, nil, nil)
    }
}
