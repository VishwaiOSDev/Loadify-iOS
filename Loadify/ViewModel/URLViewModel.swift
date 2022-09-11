//
//  URLViewModel.swift
//  Loadify
//
//  Created by Vishweshwaran on 18/06/22.
//

import Foundation
import LogKit

protocol Detailable: Navigatable {
    func getVideoDetails(for url: String) async
}

final class URLViewModel: Detailable {
    
    @Published var shouldNavigateToDownload: Bool = false
    @Published var showLoader: Bool = false
    @Published var error: Error? = nil
    
    var apiService: DataService
    var details: VideoDetails? = nil
    
    init(apiService: DataService = ApiService()) {
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
            Log.debug(error.localizedDescription)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.showLoader = false
                self.error = error
            }
        }
    }
}
