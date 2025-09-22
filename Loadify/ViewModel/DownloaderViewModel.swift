//
//  ViewDetailsViewModel.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import SwiftUI
import Combine
import LoggerKit
import Haptific
import LoadifyEngine

@MainActor
protocol Downloadable: Loadable, DownloadableError {
    var downloadStatus: DownloadStatus { get set }
    
    func downloadVideo(url: String) async
}

@Observable final class DownloaderViewModel: Downloadable {
    
    // Published properties for observing changes
    var showLoader: Bool = false
    var downloadError: Error? = nil
    var errorMessage: String? = nil
    var showSettingsAlert: Bool = false
    var isDownloading: Bool = false
    var downloadStatus: DownloadStatus = .none
    var progress: Double = .zero
        
    // Services for handling photos and file operations
    @ObservationIgnored private lazy var photoService: PhotosServiceProtocol = PhotosService()
    @ObservationIgnored private lazy var fileService: FileServiceProtocol = FileService()
    
    @ObservationIgnored nonisolated(unsafe) private var downloader: Downloader?
    
    init() {
        Logger.initLifeCycle("DownloaderViewModel init", for: self)
        self.downloader = Downloader()
    }
    
    // Async function to download a video
    func downloadVideo(url: String) async {
        downloader?.delegate = self
        do {
            showLoader = true
            withAnimation(.linear(duration: 0.5)) {
                errorMessage = nil
            }
            
            // Check for necessary permissions (in this case, Photos permission)
            try await photoService.checkForPhotosPermission()
            
            try downloader?.download(url)
        } catch PhotosError.permissionDenied {
            withAnimation {
                showSettingsAlert = true
                showLoader = false
                downloadStatus = .none
            }
            
            notifyWithHaptics(for: .warning)
        } catch {
            withAnimation {
                downloadError = error
                showLoader = false
                downloadStatus = .failed
            }
            
            notifyWithHaptics(for: .error)
        }
    }
    
    private func saveMediaToPhotosAlbumIfCompatiable(
        at filePath: String,
        downloadType: Downloader.DownloadType
    ) throws {
        switch downloadType {
        case .video:
            // Save video to Photos album if compatible
            if !UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(filePath) {
                throw DownloadError.notCompatible
            }
            UISaveVideoAtPathToSavedPhotosAlbum(filePath, nil, nil, nil)
        case .photo:
            // Save photo to Photos album if compatible
            guard let image = UIImage(contentsOfFile: filePath) else {
                throw DownloadError.notCompatible
            }
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
    
    deinit {
        downloader?.invalidateTasks()
        Logger.deinitLifeCycle("DownloaderViewModel deinit", for: self)
    }
}

// MARK: - Downloader delegation
extension DownloaderViewModel: DownloaderDelegate {
    
    func downloader(didUpdateProgress progress: CGFloat) {
        if showLoader {
            showLoader = false
            isDownloading = true
        }
        Logger.debug("Downloading... \(progress)")
        self.progress = progress
    }
    
    func downloader(didCompleteDownloadWithURL url: URL, forType: Downloader.DownloadType) {
        do {
            let filePath = fileService.getTemporaryFilePath()
            try fileService.moveFile(from: url, to: filePath)
            
            // Save media to Photos album if compatible
            try saveMediaToPhotosAlbumIfCompatiable(at: filePath.path, downloadType: forType)
            
            
            isDownloading = false
            withAnimation {
                downloadStatus = .downloaded
            }
            
            notifyWithHaptics(for: .success)
        } catch {
            showLoader = false
            withAnimation {
                downloadStatus = .failed
            }
        }
    }
    
    func downloader(didFailWithError error: Error) {
        showLoader = false
        errorMessage = errorMessage
        errorMessage = "Failed to Download"
        withAnimation {
            downloadStatus = .failed
        }
        
        notifyWithHaptics(for: .error)
    }
    
    func downloader(didFailWithErrorMessage errorMessage: String) {
        showLoader = false
        self.errorMessage = errorMessage
        withAnimation {
            downloadStatus = .failed
        }
        
        notifyWithHaptics(for: .error)
    }
}
