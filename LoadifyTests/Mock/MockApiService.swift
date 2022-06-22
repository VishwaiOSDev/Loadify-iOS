//
//  MockApiService.swift
//  LoadifyTests
//
//  Created by Vishweshwaran on 13/06/22.
//

import Foundation
@testable import Loadify

final class MockApiService: DataService, Mockable {
    
    func fetchVideoDetailsFromApi(for url: String) async throws -> VideoDetails {
        if url == "https://www.youtube.com/watch?v=66XwG1CLHuU" {
            return loadJSON(fileName: "VideoDetailsResponse", type: VideoDetails.self)
        } else {
            throw DetailsError.notVaildYouTubeUrl
        }
    }
    
    func downloadVideo(for url: String, quality: VideoQuality) async throws { }
}
