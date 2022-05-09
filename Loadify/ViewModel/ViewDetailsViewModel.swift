//
//  ViewDetailsViewModel.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import Foundation
import SwiftUI

enum VideoQuality {
    case Low, medium, high
}

protocol URLConfigable: ObservableObject {
    var url: String { get set }
}

protocol Downloadable: URLConfigable {
    func getVideoDetails(for url: URL)
    func downloadAudio(from url: URL)
    func downloadVideo(from url: URL, for quality: VideoQuality)
}

final class DownloaderViewModel: Downloadable {
    
    @Published var url: String = ""
    let apiService: DataService
    
    init(apiService: DataService = ApiService()) {
        self.apiService = apiService
    }
    
    func getVideoDetails(for url: URL) {
        apiService.getVideoDetails(from: url)
    }
    
    func downloadAudio(from url: URL) {
        
    }
    
    func downloadVideo(from url: URL, for quality: VideoQuality) {
        
    }
}
