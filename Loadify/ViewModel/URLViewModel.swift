//
//  URLViewModel.swift
//  Loadify
//
//  Created by Vishweshwaran on 18/06/22.
//

import Foundation
import LoggerKit
import Haptific
import LoadifyEngine

protocol Detailable: Navigatable {
    func getVideoDetails(for url: String) async
}

@MainActor
@Observable final class URLViewModel: Detailable {
    
    // Published properties for observing changes
    var shouldNavigateToDownload: Bool = false
    var errorMessage: String? = nil
    var showLoader: Bool = false
    
    private let loadifyEngine = LoadifyEngine()
    
    var platformType: PlatformType? = nil
    var details: LoadifyResponse? = nil
    
    var fetcher: DetailsFetching = DetailsFetcher()
    
    init() {
        Logger.initLifeCycle("URLViewModel init", for: self)
    }
    
    // Async function to get video details for a given URL
    func getVideoDetails(for url: String) async {
        DispatchQueue.main.async { [weak self] in
            self?.showLoader = true
        }
        
        do {
            // Validate if the input URL is a valid URL
            try checkInputTextIsValidURL(text: url)
            
            // Determine the platform type based on the URL
            //            let pattern = Loadify.RegEx.instagram
            //            let isInstagram = url.doesMatchExist(pattern, inputText: url)
            //            platformType = isInstagram ? .instagram : .youtube
            //
            // Fetch details based on the platform type
            //            switch platformType {
            //            case .youtube:
            //                let response: YouTubeDetails = try await fetcher.loadDetails(for: url, to: .youtube)
            //                self.details = response
            //            case .instagram:
            //                let response: [InstagramDetails] = try await fetcher.loadDetails(for: url, to: .instagram)
            //                self.details = response
            //            case .none:
            //                fatalError("Platform type not available")
            //            }
            
            self.platformType = .instagram
            
            let response: LoadifyResponse = try await loadifyEngine.fetchVideoDetails(for: url)
            self.details = response
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.showLoader = false
                self.shouldNavigateToDownload = true
                
            }
            
            notifyWithHaptics(for: .success)
        } catch let error as NetworkError {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                guard let self else { return }
                
                self.showLoader = false
                
                // Map specific network errors to error messages
                switch error {
                case .invalidResponse(let message):
                    self.errorMessage = message
                case .badRequest(let message):
                    self.errorMessage = message
                case .unauthorized(let message):
                    self.errorMessage = message
                case .forbidden(let message):
                    self.errorMessage = message
                case .notFound(let message):
                    self.errorMessage = message
                case .serverError(let message):
                    self.errorMessage = message
                case .unknownError(let message):
                    self.errorMessage = message
                }
                
                notifyWithHaptics(for: .error)
            }
        } catch {
            Logger.error("Failed with error: ", error.localizedDescription)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                guard let self else { return }
                
                self.showLoader = false
                self.errorMessage = error.localizedDescription
            }
            
            notifyWithHaptics(for: .error)
        }
    }
    
    private func checkInputTextIsValidURL(text: String) throws {
        guard text.doesMatchExist(Loadify.RegEx.url, inputText: text) else {
            let errorMessage = "The URL you entered is not valid"
            throw NetworkError.badRequest(message: errorMessage)
        }
    }
    
    deinit {
        Logger.deinitLifeCycle("URLViewModel deinit", for: self)
    }
}
