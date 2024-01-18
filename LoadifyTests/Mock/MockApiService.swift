//
//  MockApiService.swift
//  LoadifyTests
//
//  Created by Vishweshwaran on 13/06/22.
//

import Foundation
@testable import Loadify

class URLMockViewModel: Detailable {
    
    var details: Decodable? = nil
    var errorMessage: String?
    var showLoader: Bool = false
    var shouldNavigateToDownload: Bool = false
    
    private var fetcher: DetailsFetching
    
    init(fetcher: DetailsFetching) {
        self.fetcher = fetcher
    }
    
    func getVideoDetails(for url: String) async {
        do {
            switch url {
            case "instagram_response":
                let response: [InstagramDetails] = try await fetcher.loadDetails(for: url, to: .instagram)
                details = response
            default:
                let response: YouTubeDetails = try await fetcher.loadDetails(for: url, to: .youtube)
                details = response
            }
        } catch {
            Logger.error("Failed with err: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }
    }
}

class DetailsFetcherMock: DetailsFetching, Mockable {
    
    func loadDetails<T: Decodable>(for url: String, to platform: PlatformType) async throws -> T {
        do {
            return try loadJSON(fileName: url, type: T.self)
        } catch {
            throw NetworkError.badRequest(message: "The request was invalid. Please check your input.")
        }
    }
}

// MARK: - Detailable+Extension

extension Detailable {
    
    func onDisappear() {}
}
