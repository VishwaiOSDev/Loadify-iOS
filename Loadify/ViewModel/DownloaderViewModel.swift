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

@MainActor
@Observable final class DownloaderViewModel: Downloadable, ViewLifeCycle {
    
    // Published properties for observing changes
    var showLoader: Bool = false
    var downloadError: Error? = nil
    var errorMessage: String? = nil
    var showSettingsAlert: Bool = false
    var isDownloading: Bool = false
    var downloadStatus: DownloadStatus = .none
    var progress: Double = .zero
    
    var details: LoadifyResponse? = nil
    
    // Services for handling photos and file operations
    @ObservationIgnored private lazy var photoService: PhotosServiceProtocol = PhotosService()
    @ObservationIgnored private lazy var fileService: FileServiceProtocol = FileService()
    
    @ObservationIgnored nonisolated(unsafe) private var downloader: Downloader?
        
    init(details: LoadifyResponse? = nil) {
        Logger.initLifeCycle("DownloaderViewModel init", for: self)
        self.details = details
        self.downloader = Downloader()
    }
    
    // Async function to download a video
    func downloadVideo(url: String) async {
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
            
            try downloader?.download(url)
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
    
    func onDisappear() {
        self.details = nil
        self.downloader = nil
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
