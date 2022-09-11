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

protocol DataService {
    func fetchVideoDetailsFromApi(for url: String) async throws -> VideoDetails
    /// Move downloadVideo to new protocol
    func downloadVideo(for url: String, quality: VideoQuality) async throws
}

class ApiService: DataService {
    
    var photoService: PhotosServiceProtocol
    var fileService: FileServiceProtocol
    private var baseURL: String {
        get throws {
            guard let apiURL = _baseURL else { throw DetailsError.invaildApiUrl }
            return apiURL
        }
    }
    private var _baseURL: String?
    
    init(
        urlType: Api.URLType = .preAlpha,
        photoService: PhotosServiceProtocol = PhotosService(),
        fileService: FileServiceProtocol = FileService()
    ) {
        self._baseURL = Api.getBaseUrl(urlType)
        self.photoService = photoService
        self.fileService = fileService
    }
    
    func fetchVideoDetailsFromApi(for url: String) async throws -> VideoDetails {
        try await NetworkKit
            .shared
            .requestJSON(Endpoint.details(youtubeURL: url), type: VideoDetails.self)
    }
    
    func downloadVideo(for url: String, quality: VideoQuality) async throws {
        try await photoService.checkForPhotosPermission()
        let filePath = fileService.getTemporaryFilePath()
        let data = try await NetworkKit
            .shared
            .requestData(Endpoint.download(youtubeURL: url, quality: quality))
        try data.write(to: filePath)
        try checkVideoIsCompatible(at: filePath.path)
        UISaveVideoAtPathToSavedPhotosAlbum(filePath.path, nil, nil, nil)
    }
}
