//
//  ViewDetailsViewModel.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import SwiftUI
import SwiftDI

protocol Detailable: Navigatable {
    func getVideoDetails(for url: String)
}

protocol Downloadable: Loadable {
    func downloadAudio(from url: URL)
    func downloadVideo(with quality: VideoQuality)
}

final class URLViewModel: Detailable, Downloadable {
    
    @Published var url: String = "https://www.youtube.com/watch?v=CYYtLXfquy0"
    @Published var details: VideoDetails?
    @Published var showProgessView: Bool = false
    @Published var shouldNavigateToDownload: Bool = false
    @Inject var apiService: DataService
    
    func getVideoDetails(for url: String) {
        DispatchQueue.main.async {
            self.showProgessView = true
        }
        guard let apiUrl = URL(string: "https://api.tikapp.ml/api/yt/details?url=\(url)") else { return }
        apiService.getVideoDetails(url: apiUrl) { details in
            DispatchQueue.main.async {
                self.details = details
                self.showProgessView = false
                self.shouldNavigateToDownload = true
            }
        }
    }
    
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
