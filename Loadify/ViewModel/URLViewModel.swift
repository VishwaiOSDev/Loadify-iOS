//
//  URLViewModel.swift
//  Loadify
//
//  Created by Vishweshwaran on 18/06/22.
//

import Foundation
import LoggerKit

protocol ViewLifyCycle {
    func onDisappear()
}

protocol Detailable: Navigatable, ViewLifyCycle {
    func getVideoDetails(for url: String) async
}

final class URLViewModel: Detailable {
    
    @Published var shouldNavigateToDownload: Bool = false
    @Published var showLoader: Bool = false
    @Published var error: Error? = nil
    
    var details: VideoDetails? = nil
    
    private var apiService: FetchService?
    
    init() {
        Logger.initLifeCycle("URLViewModel init", for: self)
    }
    
    func getVideoDetails(for url: String) async {
        do {
            apiService = ApiService()
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.showLoader = true
            }
            let response = try await apiService!.fetchVideoDetailsFromApi(for: url)
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.details = response
                self.showLoader = false
                self.shouldNavigateToDownload = true
            }
        } catch {
            Logger.error("Failed with err: ", error.localizedDescription)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                guard let self else { return }
                self.showLoader = false
                self.error = error
            }
        }
    }
    
    func onDisappear() {
        details = nil
        apiService = nil
    }
    
    deinit {
        Logger.deinitLifeCycle("URLViewModel deinit", for: self)
    }
}
