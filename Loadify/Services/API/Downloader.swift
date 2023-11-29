//
//  Downloader.swift
//  Loadify
//
//  Created by Vishweshwaran on 2023-11-29.
//

import Foundation

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

    private lazy var session: URLSessionProtocol = URLSession(
        configuration: config,
        delegate: self,
        delegateQueue: OperationQueue()
    )
    
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
                delegate?.downloader(didFailWithError: NetworkError.invalidResponse(message: nil))
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
