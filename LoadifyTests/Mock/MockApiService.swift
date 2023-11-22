//
//  MockApiService.swift
//  LoadifyTests
//
//  Created by Vishweshwaran on 13/06/22.
//

import Foundation
@testable import Loadify

//class URLMockViewModel: Detailable {
//    
//    var details: VideoDetails? = nil
//    var showLoader: Bool = false
//    var error: Error? = nil
//    var shouldNavigateToDownload: Bool = false
//    
//    private var apiService: FetchService
//    
//    init(apiService: FetchService) {
//        self.apiService = apiService
//    }
//    
//    func getVideoDetails(for url: String) async {
//        do {
//            let response = try await apiService.fetchVideoDetailsFromApi(for: url)
//            details = response
//        } catch { }
//    }
//}
//
//final class MockApiService: FetchService, Mockable {
//    
//    func fetchVideoDetailsFromApi(for url: String) async throws -> VideoDetails {
//        guard url == "https://www.youtube.com/watch?v=66XwG1CLHuU" else {
//            throw NetworkError.badInput(error: APIError(statusCode: 400, data: nil))
//        }
//        return loadJSON(fileName: "VideoDetailsResponse", type: VideoDetails.self)
//    }
//}
