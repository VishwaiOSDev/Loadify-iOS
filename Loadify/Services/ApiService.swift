//
//  ApiService.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/8/22.
//

import UIKit
import Photos
import SwiftDI

protocol DataService {
    func getVideoDetails(for url: String) async throws -> VideoDetails
    func downloadVideo(for url: String, quality: VideoQuality) async throws
}

enum ServerError: Error, LocalizedError {
    case notValidDomain
    case internalServerError
    case requestedQualityUnavailable
    
    var errorDescription: String? {
        switch self {
        case .notValidDomain: return "Error: Not a YouTube domain"
        case .internalServerError: return "Something went wrong"
        case .requestedQualityUnavailable: return "The requested quality is not supported"
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
    
    var errorDescription: String? {
        switch self {
        case .notCompatible: return "This video is not compatible to save"
        case .fatalError: return "Something went worng. Please try again later"
        case .qualityNotAvailable: return "The request quality is not available"
        }
    }
}

class ApiService: DataService {
    
    @Inject var photoService: PhotosServiceProtocol
    @Inject var fileSerivce: FileServiceProtocol
    
    func getVideoDetails(for url: String) async throws -> VideoDetails {
        try checkIsValidUrl(url)
        let apiUrl = Api.baseUrl + Api.YouTube.getDetails.rawValue + url
        let url = try getUrl(from: apiUrl)
        let request = createUrlRequest(for: url)
        let (data, urlResponse) = try await URLSession.shared.data(from: request)
        try await checkForServerErrors(for: urlResponse, with: data)
        return decode(data, to: VideoDetails.self)
    }
    
    func downloadVideo(for url: String, quality: VideoQuality) async throws {
        try checkIsValidUrl(url)
        let apiUrl = (
            Api.baseUrl +
            Api.YouTube.downloadVideo.rawValue +
            url +
            Api.YouTube.videoQuality.rawValue +
            quality.rawValue
        )
        let url = try getUrl(from: apiUrl)
        try await photoService.checkForPhotosPermission()
        let request = createUrlRequest(for: url)
        let filePath = fileSerivce.getTemporaryFilePath()
        let (data, urlResponse) = try await URLSession.shared.data(from: request)
        try await checkForServerErrors(for: urlResponse, with: data)
        try data.write(to: filePath)
        try checkVideoIsCompatible(at: filePath.path)
        UISaveVideoAtPathToSavedPhotosAlbum(filePath.path, nil, nil, nil)
    }
}

extension ApiService {
    
    private func getUrl(from urlString: String) throws ->  URL {
        guard let url = URL(string: urlString) else { throw DetailsError.invaildApiUrl }
        return url
    }
    
    private func checkVideoIsCompatible(at filePath: String) throws {
        if !UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(filePath) {
            throw DownloadError.notCompatible
        }
    }
}
