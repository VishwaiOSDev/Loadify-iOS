//
//  ApiService.swift
//  Loadify
//
//  Created by Vishweshwaran on 2023-09-17.
//

import Foundation

struct DetailFetcher {
    
    private var session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func loadDetails(for youtubeURL: String) async throws -> VideoDetails {
        let request = try API.details(youtubeURL: youtubeURL).createRequest()
        
        let (data, httpResponse) = try await session.fetchData(for: request)
        
        guard let mimeType = httpResponse.mimeType, mimeType.contains("json") else {
            throw NetworkError.invalidResponse(message: "Invalid MIMEType")
        }
        
        return try JSONDecoder().decode(VideoDetails.self, from: data)
    }
}

struct Downloader {
    
    private var session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func download(youtubeURL: String, quality: VideoQuality) async throws -> URL  {
        let request = try API.download(youtubeURL: youtubeURL, quality: quality).createRequest()
        
        let (url, _) = try await session.downloadData(for: request)
        
        return url
    }
}
