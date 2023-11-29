//
//  DetailsFetcher.swift
//  Loadify
//
//  Created by Vishweshwaran on 2023-11-29.
//

import Foundation

struct DetailsFetcher {
    
    private var session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    // Asynchronously loads details from a URL for a specific platform
    func loadDetails<T: Decodable>(for url: String, to platform: PlatformType) async throws -> T {
        let request = try API.details(forPlatform: platform, url: url).createRequest()
        
        let (data, httpResponse) = try await session.fetch(for: request)
        
        // Check if the response contains a valid MIME type indicating JSON
        guard let mimeType = httpResponse.mimeType, mimeType.contains("json") else {
            throw NetworkError.invalidResponse(message: "Invalid MIMEType")
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
