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
        let (data, httpResponse) = try await session.fetch(for: request)
        
        // Check if the response contains a valid MIME type indicating JSON
        guard let mimeType = httpResponse.mimeType, mimeType.contains("json") else {
            throw NetworkError.invalidResponse(message: "Invalid MIMEType")
        }
        
        // Decode the received JSON data into the specified generic type
        return try JSONDecoder().decode(T.self, from: data)
    }
}

protocol DownloaderDelegate: AnyObject {
    func downloader(didUpdateProgress progress: CGFloat)
    func downloader(didCompleteDownloadWithURL url: URL, forType: Downloader.DownloadType)
    func downloader(didFailWithError error: Error)
}

final class Downloader: NSObject {
    
    // Enum defining the types of content that can be downloaded
    enum DownloadType {
        case video, photo
    }
    
    weak var delegate: DownloaderDelegate?
    
    private let id = "\(Bundle.main.bundleIdentifier!).background"
    
    private var config: URLSessionConfiguration  {
        return .background(withIdentifier: id)
    }

    // URLSessionProtocol allows for dependency injection, making testing easier
    private lazy var session: URLSessionProtocol = URLSession(
        configuration: config,
        delegate: self,
        delegateQueue: OperationQueue()
    )
    
    // Initializer with a default URLSession.shared
    override init() {
        super.init()
        Logger.initLifeCycle("Downloader Service init", for: self)
    }
    
    // Asynchronously downloads content from a URL for a specific platform with a given quality
    func download(
        _ url: String,
        for platform: PlatformType,
        withQuality quality: VideoQuality
    ) throws {
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

        session.download(for: request)
    }

    deinit {
        Logger.deinitLifeCycle("Downloader Service deinit", for: self)
    }
}

extension Downloader: URLSessionDownloadDelegate {
    
    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL
    ) {
        defer { session.finishTasksAndInvalidate() }
        do {
            let URLResponse = downloadTask.response
            guard let httpResponse = try URLResponse?.handleStatusCodeAndReturnHTTPResponse() else {
                /// throw error using delegate
                return
            }
            
            // Determine the type of content based on the received MIME type
            let downloadType: DownloadType = switch httpResponse.mimeType {
            case "video/mp4":
                DownloadType.video
            case "image/jpeg":
                DownloadType.photo
            default:
                DownloadType.video
            }
            
            delegate?.downloader(didCompleteDownloadWithURL: location, forType: downloadType)
        } catch {
            delegate?.downloader(didFailWithError: error)
        }
    }
    
    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64
    ) {
        let progress = downloadTask.progress.fractionCompleted
        delegate?.downloader(didUpdateProgress: progress)
    }
}
