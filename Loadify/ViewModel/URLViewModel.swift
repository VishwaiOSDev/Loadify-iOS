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
    
    var apiService: DataService? = nil
    var details: VideoDetails? = nil
    
    init(apiService: DataService = ApiService()) {
        self.apiService = apiService
        Log.verbose("Init")
    }
    
    func getVideoDetails(for url: String) async {
        do {
            guard let apiService else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.showLoader = true
            }
            let response = try await apiService.fetchVideoDetailsFromApi(for: url)
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.details = response
                self.showLoader = false
                self.shouldNavigateToDownload = true
            }
        } catch {
            Log.debug(error.localizedDescription)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                guard let self else { return }
                self.showLoader = false
                self.error = error
            }
        }
    }
    
    deinit {
        Log.verbose("DeInit")
        apiService = nil
        details = nil
    }
}
