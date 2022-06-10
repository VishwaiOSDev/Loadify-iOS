//
//  ApiService.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/8/22.
//

import UIKit
import Photos
import SwiftDI
import Foundation

protocol DataService {
    func getVideoDetails(for url: String) async throws -> VideoDetails
    func downloadVideo(for url: String) async throws
}

enum ServerError: Error, LocalizedError {
    case notValidDomain
    case internalServerError
    
    var errorDescription: String? {
        switch self {
        case .notValidDomain: return "Error: Not a YouTube domain"
        case .internalServerError: return "Something went wrong"
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
        case .invaildApiUrl: return "This is not valid URL"
        case .notVaildYouTubeUrl: return "This is not a valid YouTube URL"
        }
    }
}

enum DownloadError: Error, LocalizedError {
    case notCompatible
    case fatalError
    
    var errorDescription: String? {
        switch self {
        case .notCompatible: return "This video is not compatible to save"
        case .fatalError: return "Something went worng. Please try again later"
        }
    }
}

class ApiService: DataService {
    
    @Inject var photoService: PhotosServiceProtocol
    @Inject var fileSerivce: FileServiceProtocol
    
    func getVideoDetails(for url: String) async throws -> VideoDetails {
        try checkIsValidUrl(url)
        let apiUrl = "https://api.tikapp.ml/api/yt/details?url=\(url)"
        guard let url = URL(string: apiUrl) else { throw DetailsError.invaildApiUrl }
        let request = createUrlRequest(for: url)
        let (data, urlResponse) = try await URLSession.shared.data(from: request)
        try await checkForServerErrors(for: urlResponse, with: data)
        return decode(data, to: VideoDetails.self)
    }
}

extension ApiService {
    
    func downloadVideo(for url: String) async throws {
        try checkIsValidUrl(url)
        // TODO: - Create resuable function to use url as guard let
        let apiUrl = "https://api.tikapp.ml/api/yt/download/video/mp4?url=\(url)&video_quality=High"
        guard let url = URL(string: apiUrl) else { throw DetailsError.invaildApiUrl }
        try await photoService.checkForPhotosPermission()
        let request = createUrlRequest(for: url)
        let filePath = fileSerivce.getTemporaryFilePath()
        let (data, _) = try await URLSession.shared.data(from: request)
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
