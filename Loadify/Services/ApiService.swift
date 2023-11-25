//
//  ApiService.swift
//  Loadify
//
//  Created by Vishweshwaran on 2023-09-17.
//

import Foundation

struct DetailsFetcher {
    
    // URLSessionProtocol allows for dependency injection, making testing easier
    private var session: URLSessionProtocol
    
    // Initializer with a default URLSession.shared
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    // Asynchronously loads details from a URL for a specific platform
    func loadDetails<T: Decodable>(for url: String, to platform: PlatformType) async throws -> T {
        // Create a URLRequest using the API details endpoint for the specified platform and URL
        let request = try API.details(forPlatform: platform, url: url).createRequest()
        
        // Fetch data asynchronously for the created request
        let (data, httpResponse) = try await session.fetchData(for: request)
        
        // Check if the response contains a valid MIME type indicating JSON
        guard let mimeType = httpResponse.mimeType, mimeType.contains("json") else {
            throw NetworkError.invalidResponse(message: "Invalid MIMEType")
        }
        
        // Decode the received JSON data into the specified generic type
        return try JSONDecoder().decode(T.self, from: data)
    }
}

struct Downloader {
    
    // Enum defining the types of content that can be downloaded
    enum DownloadType {
        case video, photo
    }
    
    // URLSessionProtocol allows for dependency injection, making testing easier
    private var session: URLSessionProtocol
    // Variable to store the type of content being downloaded
    private var downloadType: DownloadType = .video
    
    // Initializer with a default URLSession.shared
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    // Asynchronously downloads content from a URL for a specific platform with a given quality
    mutating func download(
        _ url: String,
        for platform: PlatformType,
        withQuality quality: VideoQuality
    ) async throws -> (URL, DownloadType)  {
        // Create a URLRequest based on the specified platform and URL
        let request: URLRequest
        
        switch platform {
        case .youtube:
            request = try API.download(url: url, quality: quality).createRequest()
        case .instagram:
            // For Instagram, create a basic URLRequest using the provided URL string
            guard let url = URL(string: url) else {
                let errorMessage = "This is not a valid Instagram URL"
                throw NetworkError.badRequest(message: errorMessage)
            }
            request = URLRequest(url: url)
        }
        
        // Fetch data asynchronously for the created request
        let (url, httpResponse) = try await session.downloadData(for: request)
        
        // Determine the type of content based on the received MIME type
        switch httpResponse.mimeType {
        case "video/mp4":
            setDownloadType(.video)
        case "image/jpeg":
            setDownloadType(.photo)
        default:
            setDownloadType(.video)
        }
        
        // Return the downloaded URL and the determined content type
        return (url, downloadType)
    }
    
    // Private method to set the type of content being downloaded
    mutating private func setDownloadType(_ newType: DownloadType) {
        downloadType = newType
    }
}
