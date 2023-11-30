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
    func downloader(didFailWithErrorMessage errorMessage: String)
    func downloader(didFailWithError error: Error)
}

final class Downloader: NSObject {
    
    // Enum defining the types of content that can be downloaded
    enum DownloadType {
        case video, photo
    }
    
    weak var delegate: DownloaderDelegate?
    
    private var session: URLSession?
    
    override init() {
        super.init()
        Logger.initLifeCycle("Downloader Service init", for: self)
        
        let config = URLSessionConfiguration.default
        session = URLSession(
            configuration: config,
            delegate: self,
            delegateQueue: OperationQueue()
        )
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
        
        session?.download(for: request)
    }
    
    func invalidateTasks() {
        session?.finishTasksAndInvalidate()
    }
    
    deinit {
        session?.finishTasksAndInvalidate()
        Logger.deinitLifeCycle("Downloader Service deinit", for: self)
    }
}

extension Downloader: URLSessionDownloadDelegate {
        
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let error else { return }
        delegate?.downloader(didFailWithError: error)
    }
    
    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL
    ) {
        do {
            let URLResponse = downloadTask.response
            
            guard let httpResponse = try URLResponse?.handleStatusCodeAndReturnHTTPResponse() else {
                let error = NetworkError.invalidResponse(message: nil)
                delegate?.downloader(didFailWithError: error)
                return
            }
            
            // Determine the type of content based on the received MIME type
            let downloadType: DownloadType = switch httpResponse.mimeType {
            case "image/jpeg":
                DownloadType.photo
            default:
                DownloadType.video
            }
            
            delegate?.downloader(didCompleteDownloadWithURL: location, forType: downloadType)
        } catch _ as NetworkError {
            delegate?.downloader(didFailWithErrorMessage: "Download Failed")
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
        guard let response = try? downloadTask.response?.httpResponse, 
                (200...299).contains(response.statusCode) else {
            return
        }
        
        let progress = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        delegate?.downloader(didUpdateProgress: progress)
    }
}
