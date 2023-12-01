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

protocol Downloadable: Loadable, DownloadableError {
    var downloadStatus: DownloadStatus { get set }
    
    func downloadVideo(url: String, for platform: PlatformType, with quality: VideoQuality) async
}

final class DownloaderViewModel: Downloadable {
    
    // Published properties for observing changes
    @Published var showLoader: Bool = false
    @Published var downloadError: Error? = nil
    @Published var errorMessage: String? = nil
    @Published var showSettingsAlert: Bool = false
    @Published var isDownloading: Bool = false
    @Published var downloadStatus: DownloadStatus = .none
    @Published var progress: Double = .zero
    
    // Services for handling photos and file operations
    private lazy var photoService: PhotosServiceProtocol = PhotosService()
    private lazy var fileService: FileServiceProtocol = FileService()
    
    private var downloader: Downloader?
    
    init() {
        Logger.initLifeCycle("DownloaderViewModel init", for: self)
        self.downloader = Downloader()
    }
    
    // Async function to download a video
    func downloadVideo(url: String, for platform: PlatformType, with quality: VideoQuality) async {
        downloader?.delegate = self
        do {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.showLoader = true
                
                withAnimation(.linear(duration: 0.5)) {
                    self.errorMessage = nil
                }
            }
            
            // Check for necessary permissions (in this case, Photos permission)
            try await photoService.checkForPhotosPermission()
            
            try downloader?.download(url, for: platform, withQuality: quality)
        } catch PhotosError.permissionDenied {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                withAnimation {
                    self.showSettingsAlert = true
                    self.showLoader = false
                    self.downloadStatus = .none
                }
                
                notifyWithHaptics(for: .warning)
            }
        } catch {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                withAnimation {
                    self.downloadError = error
                    self.showLoader = false
                    self.downloadStatus = .failed
                }
                
                notifyWithHaptics(for: .error)
            }
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
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            if self.showLoader {
                self.showLoader = false
                self.isDownloading = true
            }

            self.progress = progress
        }
    }
    
    func downloader(didCompleteDownloadWithURL url: URL, forType: Downloader.DownloadType) {
        do {
            let filePath = fileService.getTemporaryFilePath()
            try fileService.moveFile(from: url, to: filePath)
            
            // Save media to Photos album if compatible
            try saveMediaToPhotosAlbumIfCompatiable(at: filePath.path, downloadType: forType)
                        
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.isDownloading = false
                withAnimation {
                    self.downloadStatus = .downloaded
                }
            }
            
            notifyWithHaptics(for: .success)
        } catch {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.showLoader = false
                withAnimation {
                    self.downloadStatus = .failed
                }
            }
        }
    }
    
    func downloader(didFailWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.showLoader = false
            self.errorMessage = errorMessage
            self.errorMessage = "Failed to Download"
            withAnimation {
                self.downloadStatus = .failed
            }
        }
        
        notifyWithHaptics(for: .error)
    }
    
    func downloader(didFailWithErrorMessage errorMessage: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.showLoader = false
            self.errorMessage = errorMessage
            withAnimation {
                self.downloadStatus = .failed
            }
        }
        
        notifyWithHaptics(for: .error)
    }
}
