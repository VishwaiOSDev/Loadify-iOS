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
        let apiUrl = try baseURL + Api.YouTube.getDetails.rawValue + url
        return try await NetworkKit.shared.request(apiUrl, type: VideoDetails.self)
    }
    
//    // TODO: - This function is not testable. Needed to refactor this function to make it more testable
//    func fetchVideoDetailsFromApi(for url: String) async throws -> VideoDetails {
//        try checkIsValidUrl(url)
//        let apiUrl = try baseURL + Api.YouTube.getDetails.rawValue + url
//        let url = try getUrl(from: apiUrl)
//        let request = createUrlRequest(for: url)
//        let (data, urlResponse) = try await URLSession.shared.data(from: request)
//        try await checkForServerErrors(for: urlResponse, with: data)
//        return try decode(data, to: VideoDetails.self)
//    }
    
    func downloadVideo(for url: String, quality: VideoQuality) async throws {
        try checkIsValidUrl(url)
        let apiUrl = (
            try baseURL +
            Api.YouTube.downloadVideo.rawValue +
            url +
            Api.YouTube.videoQuality.rawValue +
            quality.rawValue
        )
        let url = try getUrl(from: apiUrl)
        try await photoService.checkForPhotosPermission()
        let request = createUrlRequest(for: url)
        let filePath = fileService.getTemporaryFilePath()
        let (data, urlResponse) = try await URLSession.shared.data(from: request)
        try await checkForServerErrors(for: urlResponse, with: data)
        try data.write(to: filePath)
        try checkVideoIsCompatible(at: filePath.path)
        UISaveVideoAtPathToSavedPhotosAlbum(filePath.path, nil, nil, nil)
    }
}
