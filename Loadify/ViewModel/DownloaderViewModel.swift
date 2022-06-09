//
//  ViewDetailsViewModel.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import SwiftUI
import SwiftDI

protocol Detailable: Navigatable {
    func getVideoDetails(for url: String) async
}

protocol Downloadable: Loadable, DownloadableError {
    func downloadAudio(from url: URL)
    func downloadVideo(with quality: VideoQuality) async
}

final class DownloaderViewModel: Detailable, Downloadable {
    
    @Published var url: String = "https://www.youtube.com/watch?v=jwmS1gc9S5A"
    @Published var details: VideoDetails? = nil
    @Published var showLoader: Bool = false
    @Published var detailsError: Error? = nil
    @Published var downloadError: Error? = nil
    @Published var showSettingsAlert: Bool = false
    @Published var shouldNavigateToDownload: Bool = false
    @Inject var apiService: DataService
    
    func getVideoDetails(for url: String) async {
        do {
            DispatchQueue.main.async {
                self.showLoader = true
            }
            let response = try await apiService.getVideoDetails(for: url)
            DispatchQueue.main.async {
                self.details = response
                self.showLoader = false
                self.shouldNavigateToDownload = true
            }
        } catch {
            DispatchQueue.main.async {
                self.showLoader = false
                self.detailsError = error
            }
        }
    }
}

extension DownloaderViewModel {
    
    func downloadAudio(from url: URL) {
        
    }
    
    func downloadVideo(with quality: VideoQuality) async {
        do {
            DispatchQueue.main.async {
                self.showLoader = true
            }
            try await apiService.downloadVideo(for: url)
            DispatchQueue.main.async {
                self.showLoader = false
            }
        } catch PhotosError.permissionDenied {
            DispatchQueue.main.async {
                self.showSettingsAlert = true
                self.showLoader = false
            }
        } catch {
            DispatchQueue.main.async {
                self.downloadError = error
                self.showLoader = false
            }
        }
    }
}
