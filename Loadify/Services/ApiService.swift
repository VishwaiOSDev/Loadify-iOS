//
//  ApiService.swift
//  Loadify
//
//  Created by Vishweshwaran on 2023-09-17.
//

import Foundation

struct DetailsFetcher {
    
    private var session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func loadDetails<T: Decodable>(for url: String, to platform: PlatformType) async throws -> T {
        let request = try API.details(forPlatform: platform, url: url).createRequest()
        
        let (data, httpResponse) = try await session.fetchData(for: request)
        
        guard let mimeType = httpResponse.mimeType, mimeType.contains("json") else {
            throw NetworkError.invalidResponse(message: "Invalid MIMEType")
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}

struct Downloader {
    
    enum DownloadType {
        case video, photo
    }
    
    private var session: URLSessionProtocol
    private var downloadType: DownloadType = .video
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    mutating func download(
        _ url: String,
        for platform: PlatformType,
        withQuality quality: VideoQuality
    ) async throws -> (URL, DownloadType)  {
        let request: URLRequest
        
        switch platform {
        case .youtube:
            request = try API.download(url: url, quality: quality).createRequest()
        case .instagram:
            guard let url = URL(string: url) else {
                let errorMessage = "This is not a valid Instagram URL"
                throw NetworkError.badRequest(message: errorMessage)
            }
            request = URLRequest(url: url)
        }
        
        let (url, httpResponse) = try await session.downloadData(for: request)
        
        switch httpResponse.mimeType {
        case "video/mp4":
            setDownloadType(.video)
        case "image/jpeg":
            setDownloadType(.photo)
        default:
            setDownloadType(.video)
        }
        
        return (url, downloadType)
    }
    
    mutating private func setDownloadType(_ newType: DownloadType) {
        downloadType = newType
    }
}
