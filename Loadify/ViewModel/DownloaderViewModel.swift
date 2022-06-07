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

protocol Downloadable: Loadable {
    func downloadAudio(from url: URL)
    func downloadVideo(with quality: VideoQuality)
}

final class DownloaderViewModel: Detailable {
    
    @Published var url: String = "https://www.youtube.com/watch?v=CYYtLXfquy0"
    @Published var details: VideoDetails? = nil
    @Published var detailsError: Error? = nil
    @Published var shouldNavigateToDownload: Bool = false
    @Inject var apiService: DataService
    
    func getVideoDetails(for url: String) async {
        do {
            let response = try await apiService.getVideoDetails(for: url)
            DispatchQueue.main.async {
                self.details = response
                self.shouldNavigateToDownload = true
            }
        } catch {
            DispatchQueue.main.async {
                self.detailsError = error
            }
        }
    }
}

extension DownloaderViewModel: Downloadable {
    
    func downloadAudio(from url: URL) {
        
    }
    
    func downloadVideo(with quality: VideoQuality) {
        guard let apiUrl = URL(string: "https://api.tikapp.ml/api/yt/download/video/mp4?url=\(url)&video_quality=Medium") else { return }
        apiService.downloadVideo(url: apiUrl) { status in
            switch status {
            case .downloaded:
                print("Video Downloaded")
            case .failed:
                print("Failed to Download the Video...")
            }
        }
    }
}
