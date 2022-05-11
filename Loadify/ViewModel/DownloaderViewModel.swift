//
//  ViewDetailsViewModel.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import Foundation
import SwiftUI

protocol Describable: ObservableObject {
    var videoDetails: VideoDetails? { get set }
}

protocol Downloadable: Describable {
    func getVideoDetails(for url: URL) async
    func downloadAudio(from url: URL)
    func downloadVideo(from url: URL, for quality: VideoQuality)
}

final class DownloaderViewModel: Downloadable {
    
    @Published var videoDetails: VideoDetails?
    private let apiService: DataService
    
    init(apiService: DataService = ApiService()) {
        self.apiService = apiService
    }
    
    func getVideoDetails(for url: URL) async {
        let videoDetails = await apiService.getVideoDetails(from: url)
        DispatchQueue.main.async {
            self.videoDetails = videoDetails
        }
    }
    
    func downloadAudio(from url: URL) {
        
    }
    
    func downloadVideo(from url: URL, for quality: VideoQuality) {
        
    }
}
