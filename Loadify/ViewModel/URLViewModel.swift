//
//  URLViewModel.swift
//  Loadify
//
//  Created by Vishweshwaran on 18/06/22.
//

import Foundation

protocol Detailable: Navigatable {
    func getVideoDetails(for url: String) async
}

final class URLViewModel: Detailable {
    
    @Published var shouldNavigateToDownload: Bool = false
    @Published var detailsError: Error? = nil
    @Published var showLoader: Bool = false
    
    var apiService: DataService
    var details: VideoDetails? = nil
    
    init(apiService: DataService = ApiService(urlType: .live)) {
        self.apiService = apiService
    }
    
    func getVideoDetails(for url: String) async {
        do {
            DispatchQueue.main.async {
                self.showLoader = true
            }
            // TODO: - Restrict the the apiSerivce.downloadVideo() func.
            let response = try await apiService.fetchVideoDetailsFromApi(for: url)
            DispatchQueue.main.async {
                self.details = response
                self.showLoader = false
                self.shouldNavigateToDownload = true
            }
        } catch {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.showLoader = false
                self.detailsError = error
            }
        }
    }
}
