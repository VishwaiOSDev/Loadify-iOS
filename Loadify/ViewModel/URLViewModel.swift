//
//  URLViewModel.swift
//  Loadify
//
//  Created by Vishweshwaran on 18/06/22.
//

import Foundation
import LoggerKit
import Haptific

protocol ViewLifyCycle {
    func onDisappear()
}

protocol Detailable: Navigatable, ViewLifyCycle {
    func getVideoDetails(for url: String) async
}

final class URLViewModel: Detailable {
    
    @Published var shouldNavigateToDownload: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showLoader: Bool = false
    
    var platformType: PlatformType? = nil
    var details: Decodable? = nil
    
    var fetcher = DetailsFetcher()
    
    init() {
        Logger.initLifeCycle("URLViewModel init", for: self)
    }
    
    func getVideoDetails(for url: String) async {
        do {
            try checkInputTextIsValidURL(text: url)
            
            let pattern = Loadify.RegEx.instagram
            let isInstagram = url.doesMatchExist(pattern, inputText: url)
            platformType = isInstagram ? .instagram : .youtube
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.showLoader = true
            }
            
            switch platformType {
            case .youtube:
                let response: YouTubeDetails = try await fetcher.loadDetails(for: url, to: .youtube)
                self.details = response
            case .instagram:
                let response: [InstagramDetails] = try await fetcher.loadDetails(for: url, to: .instagram)
                self.details = response
            case .none:
                fatalError("I won't download")
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.showLoader = false
                self.shouldNavigateToDownload = true
                
                notifyWithHaptics(for: .success)
            }
        } catch let error as NetworkError {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                guard let self else { return }
                
                self.showLoader = false
                
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
            Logger.error("Failed with err: ", error.localizedDescription)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                guard let self else { return }
                
                self.showLoader = false
                self.errorMessage = error.localizedDescription
                notifyWithHaptics(for: .error)
            }
        }
    }
    
    private func checkInputTextIsValidURL(text: String) throws {
        guard text.doesMatchExist(Loadify.RegEx.url, inputText: text) else {
            let errorMessage = "The URL you entered is not valid"
            throw NetworkError.badRequest(message: errorMessage)
        }
    }
    
    func onDisappear() {
        details = nil
    }
    
    deinit {
        Logger.deinitLifeCycle("URLViewModel deinit", for: self)
    }
}

