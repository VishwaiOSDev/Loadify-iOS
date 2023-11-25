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

// Protocol combining loading, downloading, and error-handling capabilities
protocol Downloadable: Loadable, DownloadableError {
    var isDownloaded: Bool { get set }
    var downloadStatus: DownloadStatus { get set }
    
    func downloadVideo(
        url: String,
        for platform: PlatformType,
        with quality: VideoQuality,
        isLastElement: Bool
    ) async
}

final class DownloaderViewModel: Downloadable {
    
    // Published properties for observing changes
    @Published var showLoader: Bool = false
    @Published var downloadError: Error? = nil
    @Published var showSettingsAlert: Bool = false
    @Published var isDownloaded: Bool = false
    @Published var downloadStatus: DownloadStatus = .none
    
    // Services for handling photos and file operations
    private lazy var photoService: PhotosServiceProtocol = PhotosService()
    private lazy var fileService: FileServiceProtocol = FileService()
    
    // Object responsible for downloading
    var downloader = Downloader()
    
    // Initializer for the ViewModel
    init() {
        Logger.initLifeCycle("DownloaderViewModel init", for: self)
    }
    
    // Async function to download a video
    func downloadVideo(
        url: String,
        for platform: PlatformType,
        with quality: VideoQuality,
        isLastElement: Bool = true
    ) async {
        do {
            // Show loader while downloading
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.showLoader = true
            }
            
            // Check for necessary permissions (in this case, Photos permission)
            try await photoService.checkForPhotosPermission()
            
            // Get temporary file path and download video
            let filePath = fileService.getTemporaryFilePath()
            let (tempURL, downloadType) = try await downloader.download(url, for: platform, withQuality: quality)
            try fileService.moveFile(from: tempURL, to: filePath)
            
            // Save media to Photos album if compatible
            try saveMediaToPhotosAlbumIfCompatiable(at: filePath.path, downloadType: downloadType)
            
            // If it's not the last element, return
            guard isLastElement else { return }
            
            // Update UI on the main thread after successful download
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }

                withAnimation {
                    self.showLoader = false
                    self.isDownloaded = true
                    self.downloadStatus = .downloaded
                    Logger.debug("Download Status Updated")
                }
                
                // Notify success with haptics
                notifyWithHaptics(for: .success)
            }
        } catch PhotosError.permissionDenied {
            // Handle Photos permission denied error and update UI
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                withAnimation {
                    self.showSettingsAlert = true
                    self.showLoader = false
                    self.downloadStatus = .none
                }
                
                // Notify with haptics for a warning
                notifyWithHaptics(for: .warning)
            }
        } catch {
            // Handle other errors and update UI
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                withAnimation {
                    self.isDownloaded = false
                    self.downloadError = error
                    self.showLoader = false
                    self.downloadStatus = .failed
                }
                
                // Notify with haptics for an error
                notifyWithHaptics(for: .error)
            }
        }
    }
    
    // Private function to save media to Photos album if compatible
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
    
    // Deinitializer for the ViewModel
    deinit {
        Logger.deinitLifeCycle("DownloaderViewModel deinit", for: self)
    }
}
