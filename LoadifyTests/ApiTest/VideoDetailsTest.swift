//
//  VideoDetailsTest.swift
//  LoadifyTests
//
//  Created by Vishweshwaran on 13/06/22.
//

import XCTest
@testable import Loadify

class VideoDetailsTest: XCTestCase {
    
    var urlViewModel: URLViewModel!
    let videoUrl = "https://www.youtube.com/watch?v=66XwG1CLHuU"
    let gitHubUrl = "https://github.com/VishwaiOSDev"
    
    override func setUpWithError() throws {
        urlViewModel = URLViewModel(apiService: MockApiService())
    }
    
    override func tearDownWithError() throws {
        urlViewModel = nil
    }
    
    func testFetchVideoDetailsSuccessfully() async throws {
        let expectation = XCTestExpectation(description: "Fetched Video Details")
        await urlViewModel.getVideoDetails(for: videoUrl)
        expectation.fulfill()
        wait(for: [expectation], timeout: 0.001)
        XCTAssertNotNil(urlViewModel.details)
        XCTAssertNil(urlViewModel.detailsError)
    }
    
    // TODO: - Check how to do Unit Test Task Closure
    func testInvaildUrlRequest() async {
        let expectation = XCTestExpectation(description: "No a valild YouTube URL")
        await urlViewModel.getVideoDetails(for: gitHubUrl)
        expectation.fulfill()
        wait(for: [expectation], timeout: 3)
        XCTAssertNotNil(urlViewModel.details)
        XCTAssertNotNil(urlViewModel.detailsError)
    }
}

