//
//  URLViewModel.swift
//  Loadify
//
//  Created by Vishweshwaran on 18/06/22.
//

import SwiftUI
import LoggerKit
import Haptific
import LoadifyEngine

@MainActor
protocol ViewLifeCycle {
    func onDisappear()
}

protocol Detailable: ViewLifeCycle {
    func getVideoDetails(for url: String) async
}

enum LoadifyNavigationPath: Hashable {
    case downloader(details: LoadifyResponse)
}

@MainActor
@Observable final class URLViewModel: Detailable {
    
    // Published properties for observing changes
    var errorMessage: String? = nil
    var showLoader: Bool = false
    
    var path = NavigationPath()
    
    private let loadifyEngine = LoadifyEngine(isMockEnabled: true)
    
    @ObservationIgnored var details: LoadifyResponse? = nil
    
    init() {
        Logger.initLifeCycle("URLViewModel init", for: self)
    }
    
    // Async function to get video details for a given URL
    func getVideoDetails(for url: String) async {
        showLoader = true
        
        do {
            // Validate if the input URL is a valid URL
            try checkInputTextIsValidURL(text: url)
            
            Logger.debug("Fetching Video Details...")
            
            let response: LoadifyResponse = try await loadifyEngine.fetchVideoDetails(for: url)
            self.details = response
            self.showLoader = false
//            shouldNavigateToDownload = true
            
            path.append(LoadifyNavigationPath.downloader(details: response))
            
            notifyWithHaptics(for: .success)
        } catch let error as NetworkError {
            
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
    
    func onDisappear() {
        details = nil
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
