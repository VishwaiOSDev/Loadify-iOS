//
//  MockApiService.swift
//  LoadifyTests
//
//  Created by Vishweshwaran on 13/06/22.
//

import Foundation
@testable import Loadify

final class MockApiService: DataService, Mockable {
    
    func getVideoDetails(for url: String) async throws -> VideoDetails {
        loadJSON(fileName: "VideoDetailsResponse", type: VideoDetails.self)
    }
    
    func downloadVideo(for url: String, quality: VideoQuality) async throws {
        
    }
}
