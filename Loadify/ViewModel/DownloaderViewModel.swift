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
    
    @Published var showLoader: Bool = false
    @Published var downloadError: Error? = nil
    @Published var showSettingsAlert: Bool = false
    @Published var isDownloaded: Bool = false
    @Published var downloadStatus: DownloadStatus = .none
    
    private lazy var photoService: PhotosServiceProtocol = PhotosService()
    private lazy var fileService: FileServiceProtocol = FileService()
    
    var downloader = Downloader()
    
    init() {
        Logger.initLifeCycle("DownloaderViewModel init", for: self)
    }
    
    func downloadVideo(
        url: String,
        for platform: PlatformType,
        with quality: VideoQuality,
        isLastElement: Bool = true
    ) async {
        do {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.showLoader = true
            }
            
            try await photoService.checkForPhotosPermission()
            
            let filePath = fileService.getTemporaryFilePath()
            let (tempURL, downloadType) = try await downloader.download(url, for: platform, withQuality: quality)
            try fileService.moveFile(from: tempURL, to: filePath)
            
            try saveMediaToPhotosAlbumIfCompatiable(at: filePath.path, downloadType: downloadType)
            
            guard isLastElement else { return }
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }

                withAnimation {
                    self.showLoader = false
                    self.isDownloaded = true
                    self.downloadStatus = .downloaded
                    Logger.debug("Download Status Updated")
                }
                
                notifyWithHaptics(for: .success)
            }
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
                    self.isDownloaded = false
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
            if !UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(filePath) {
                throw DownloadError.notCompatible
            }
            UISaveVideoAtPathToSavedPhotosAlbum(filePath, nil, nil, nil)
        case .photo:
            guard let image = UIImage(contentsOfFile: filePath) else {
                throw DownloadError.notCompatible
            }
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
    
    deinit {
        Logger.deinitLifeCycle("DownloaderViewModel deinit", for: self)
    }
}
