//
//  VideoDetailsTest.swift
//  LoadifyTests
//
//  Created by Vishweshwaran on 13/06/22.
//

import XCTest
import NetworkKit
@testable import Loadify

class ApiServiceTest: XCTestCase {
    
    private var urlViewModel: URLMockViewModel!
    
    fileprivate let youtubeURL = "https://www.youtube.com/watch?v=66XwG1CLHuU"
    fileprivate let githubURL = "https://github.com/VishwaiOSDev"
    
    override func setUpWithError() throws {
        urlViewModel = URLMockViewModel(apiService: MockApiService())
    }
    
    override func tearDownWithError() throws {
        urlViewModel = nil
    }
    
    func testFetchVideoDetailsSuccessfully() async throws {
        let expectation = XCTestExpectation(description: "Fetched Video Details")
        
        await urlViewModel.getVideoDetails(for: youtubeURL)
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 0.001)
        
        XCTAssertNotNil(urlViewModel.details)
        XCTAssertNil(urlViewModel.error)
    }
    
    func testInvaildYouTubeUrlRequest() async {
        let mockDataService = MockApiService()
        
        let expectation = XCTestExpectation(description: "Should fail with bad input")
        
        do {
            let _ = try await mockDataService.fetchVideoDetailsFromApi(for: githubURL)
        } catch(let error) {
            expectation.fulfill()
            let serverError = error as! NetworkError
            XCTAssertEqual(serverError, NetworkError.badInput(error: APIError(statusCode: 400)))
        }
        
        wait(for: [expectation], timeout: 0.001)
    }
    
    func testYouTubeVideoDetails() async {
        await urlViewModel.getVideoDetails(for: youtubeURL)
        
        let details = urlViewModel.details
        
        XCTAssertNotNil(details)
        XCTAssertEqual(details?.title, "Every product carbon neutral by 2030 | Apple, Apple is the best")
        XCTAssertEqual(details?.lengthSeconds.getDuration, "1:16")
        XCTAssertEqual(details?.viewCount.format, "1,913,450")
        XCTAssertEqual(details?.publishDate.formatter(), "22 Apr")
        XCTAssertEqual(details?.publishDate.formatter(.year), "2021")
        XCTAssertEqual(details?.ownerChannelName, "Apple")
        XCTAssertEqual(details?.likes.toUnits, "115.7K")
        XCTAssertEqual(details?.author.subscriberCount.toUnits, "15.8M")
        XCTAssertNotNil(details?.videoUrl)
        XCTAssertNotNil(details?.author.channelUrl)
    }
}
