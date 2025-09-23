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

protocol Detailable {
    func getVideoDetails(for url: String) async
}

enum LoadifyNavigationPath: Hashable {
    case downloader(response: LoadifyResponse)
}

@MainActor
@Observable final class URLViewModel: Detailable {
    
    var errorMessage: String? = nil
    var showLoader: Bool = false
    
    var path = NavigationPath()
    
    private let loadifyEngine = LoadifyEngine()
    
    init() {
        Logger.initLifeCycle("URLViewModel init", for: self)
    }
    
    func getVideoDetails(for url: String) async {
        showLoader = true
        
        do {
            // Validate if the input URL is a valid URL
            try checkInputTextIsValidURL(text: url)
                    
            let response: LoadifyResponse = try await loadifyEngine.fetchVideoDetails(for: url)
            showLoader = false
            
            let downloaderPath = LoadifyNavigationPath.downloader(response: response)
            path.append(downloaderPath)
            
            notifyWithHaptics(for: .success)
        } catch let error as NetworkError {
            showLoader = false
            
            // Mapping the specific network errors to error messages
            switch error {
            case .invalidResponse(let message):
                errorMessage = message
            case .badRequest(let message):
                errorMessage = message
            case .unauthorized(let message):
                errorMessage = message
            case .forbidden(let message):
                errorMessage = message
            case .notFound(let message):
                errorMessage = message
            case .serverError(let message):
                errorMessage = message
            case .unknownError(let message):
                errorMessage = message
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
