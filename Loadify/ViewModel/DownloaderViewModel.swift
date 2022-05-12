//
//  ViewDetailsViewModel.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import Foundation
import SwiftUI

protocol Describable: ObservableObject {
    var url: String { get set }
    var videoDetails: VideoDetails? { get set }
}

protocol Downloadable: Describable {
    func getVideoDetails(for url: String) async
    func downloadAudio(from url: URL)
    func downloadVideo(from url: URL, for quality: VideoQuality)
}

final class DownloaderViewModel: Downloadable {
    
    @Published var url: String = ""
    @Published var videoDetails: VideoDetails?
    @Injected(\.apiSerice) var apiService: DataService
    
    func getVideoDetails(for url: String) async {
        guard let apiUrl = URL(string: "https://api.tikapp.ml/api/yt/details?url=\(url)") else { return }
        let details = await apiService.getVideoDetails(from: apiUrl)
        print(details)
        DispatchQueue.main.async {
            self.videoDetails = details
        }
    }
    
    func downloadAudio(from url: URL) {
        
    }
    
    func downloadVideo(from url: URL, for quality: VideoQuality) {
        
    }
}
