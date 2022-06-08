//
//  ApiService.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/8/22.
//

import Photos
import UIKit
import Foundation

protocol DataService {
    func getVideoDetails(for url: String) async throws -> VideoDetails
    func downloadVideo(for url: String) async throws
}

enum ServerError: Error, LocalizedError {
    case internalServerError
    
    var errorDescription: String? {
        switch self {
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

class ApiService: DataService {
    
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
        let request = createUrlRequest(for: url)
        // TODO: - Create new service for FileManager
        let filePath = FileManager.default.temporaryDirectory.appendingPathComponent("\(UUID().uuidString).mp4")
        let (data, _) = try await URLSession.shared.data(from: request)
        do {
            try data.write(to: filePath)
            UISaveVideoAtPathToSavedPhotosAlbum(filePath.path, nil, nil, nil)
        } catch {
            fatalError("Failed to download the video file...\(error)")
        }
    }
}
