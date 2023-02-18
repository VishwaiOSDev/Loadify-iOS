//
//  URLViewModel.swift
//  Loadify
//
//  Created by Vishweshwaran on 18/06/22.
//

import Foundation
import LoggerKit

protocol Detailable: Navigatable {
    func getVideoDetails(for url: String) async
}

final class URLViewModel: Detailable {
    
    @Published var shouldNavigateToDownload: Bool = false
    @Published var showLoader: Bool = false
    @Published var error: Error? = nil
    
    var details: VideoDetails? = nil
    
    lazy private var apiService: FetchService = ApiService()
    
    init() {
        Logger.initialize("URLViewModel Init - (\(Unmanaged.passUnretained(self).toOpaque()))")
    }
    
    func getVideoDetails(for url: String) async {
        do {
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
            Logger.debug("Failed with err: ", error.localizedDescription)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                guard let self else { return }
                self.showLoader = false
                self.error = error
            }
        }
    }
    
    deinit {
        details = nil
        Logger.teardown("URLViewModel Deinit - (\(Unmanaged.passUnretained(self).toOpaque()))")
    }
}
