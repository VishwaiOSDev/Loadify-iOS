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
    
    private var session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func download(_ url: String, for platform: PlatformType, withQuality quality: VideoQuality) async throws -> URL  {
        let request: URLRequest
        
        switch platform {
        case .youtube:
            request = try API.download(url: url, quality: quality).createRequest()
        case .instagram:
            guard let url = URL(string: url) else { throw URLError(.badURL) }
            request = URLRequest(url: url)
        }
        
        let (url, _) = try await session.downloadData(for: request)
        
        return url
    }
}
