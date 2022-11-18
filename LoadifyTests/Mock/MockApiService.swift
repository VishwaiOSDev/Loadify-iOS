//
//  MockApiService.swift
//  LoadifyTests
//
//  Created by Vishweshwaran on 13/06/22.
//

import Foundation
@testable import Loadify

class URLMockViewModel: Detailable {
    
    var details: VideoDetails? = nil
    var showLoader: Bool = false
    var error: Error? = nil
    var shouldNavigateToDownload: Bool = false
    
    private var apiService: FetchService
    
    init(apiService: FetchService) {
        self.apiService = apiService
    }
    
    func getVideoDetails(for url: String) async {
        do {
            let response = try await apiService.fetchVideoDetailsFromApi(for: url)
            details = response
        } catch { }
    }
}
