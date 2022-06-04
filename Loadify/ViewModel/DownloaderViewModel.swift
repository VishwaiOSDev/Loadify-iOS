//
//  DownloaderViewModel.swift
//  Loadify
//
//  Created by Vishweshwaran on 04/06/22.
//

import SwiftUI
import SwiftDI

// TODO: - Refactor the Protocols
protocol Downloadable {
    func downloadAudio(from url: URL)
    func downloadVideo(with quality: VideoQuality)
}

final class DownloderViewModel: Urlable, Downloadable {
    
    // TODO: - Refactor the URL
    @Published var url: String = "https://www.youtube.com/watch?v=CYYtLXfquy0"
    @Inject var apiService: DataService

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
