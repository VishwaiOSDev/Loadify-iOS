//
//  ViewDetailsViewModel.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import SwiftUI
import Combine
import LogKit

protocol Downloadable: Loadable, DownloadableError {
    var downloadProgress: Double { get set }
    var isDownloaded: Bool { get set }
    
    func downloadVideo(url: String, with quality: VideoQuality) async
}

final class DownloaderViewModel: Downloadable {
    
    @Published var details: VideoDetails? = nil
    @Published var showLoader: Bool = false
    @Published var detailsError: Error? = nil
    @Published var downloadError: Error? = nil
    @Published var showSettingsAlert: Bool = false
    @Published var isDownloaded: Bool = false
    @Published var shouldNavigateToDownload: Bool = false
    @Published var downloadProgress: Double = 0.0
    
    let apiService: DownloadService
    private var anyCancellable: Set<AnyCancellable> = []
    
    init(apiService: DownloadService = ApiService()) {
        self.apiService = apiService
    }
    
    func downloadVideo(url: String, with quality: VideoQuality) async {
        do {
            try await apiService.downloadVideo(for: url, quality: quality)
            apiService.downloadProgress
                .sink(receiveCompletion: { _ in
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        withAnimation {
                            self.showLoader = false
                            self.isDownloaded = true
                            self.downloadProgress = 0.0
                        }
                    }
                }, receiveValue: { [weak self] progress in
                    guard let self else { return }
                    DispatchQueue.main.async {
                        withAnimation {
                            self.showLoader = true
                            self.downloadProgress = progress
                        }
                    }
                })
                .store(in: &anyCancellable)
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
