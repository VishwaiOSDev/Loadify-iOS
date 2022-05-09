//
//  ViewDetailsViewModel.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import Foundation
import SwiftUI

protocol URLConfigable: ObservableObject {
    var url: String { get set }
    var isLoading: Bool { get set }
}

protocol Downloadable: URLConfigable {
    func getVideoDetails(for url: URL)
    func downloadAudio(from url: URL)
    func downloadVideo(from url: URL, for quality: VideoQuality)
}

final class DownloaderViewModel: Downloadable {
    
    @Published var url: String = ""
    @Published var isLoading: Bool = false
    let apiService: DataService
    
    init(apiService: DataService = ApiService()) {
        self.apiService = apiService
    }
    
    func getVideoDetails(for url: URL) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            DispatchQueue.main.async {
                self?.isLoading = true
            }
            self?.apiService.getVideoDetails(from: url)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self?.isLoading = false
            }
        }
    }
    
    func downloadAudio(from url: URL) {
        
    }
    
    func downloadVideo(from url: URL, for quality: VideoQuality) {
        
    }
}
