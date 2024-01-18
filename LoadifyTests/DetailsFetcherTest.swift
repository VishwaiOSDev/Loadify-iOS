//
//  DetailsFetcherTest.swift
//  LoadifyTests
//
//  Created by Vishweshwaran on 13/06/22.
//

import XCTest
@testable import Loadify

class DetailsFetcherTest: XCTestCase {
    
    private var viewModel: URLMockViewModel!
    
    override func setUpWithError() throws {
        viewModel = URLMockViewModel(fetcher: DetailsFetcherMock())
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func test_fetchVideoDetailsSuccessfully_fromYouTube() async {
        let url = "youtube_response"
        let expectation = XCTestExpectation(description: "Successfully fetch video details from YouTube")
        
        await viewModel.getVideoDetails(for: url)
        expectation.fulfill()
        
        await fulfillment(of: [expectation], timeout: 0.001)
        
        XCTAssertNotNil(viewModel.details)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func test_fetchYouTubeVideoDetails() async {
        let url = "youtube_response"
        
        await viewModel.getVideoDetails(for: url)
        
        let details = viewModel.details as? YouTubeDetails
        
        XCTAssertNotNil(details)
        XCTAssertEqual(details?.title, "Every product carbon neutral by 2030 | Apple")
        XCTAssertEqual(details?.lengthSeconds.getDuration, "1:16")
        XCTAssertEqual(details?.viewCount.format, "2,799,391")
        XCTAssertEqual(details?.publishDate.formattedDate(), "22 Apr")
        XCTAssertEqual(details?.publishDate.formattedDate(.year), "2021")
        XCTAssertEqual(details?.ownerChannelName, "Apple")
        XCTAssertEqual(details?.likes.toUnits, "N/A")
        XCTAssertEqual(details?.author.subscriberCount.toUnits, "18.6M")
        XCTAssertNotNil(details?.videoUrl)
        XCTAssertNotNil(details?.author.channelUrl)
    }
    
    func test_failYouTubeUrlRequest_withInvalidInput() async {
        let invalidURL = "https://github.com/VishwaiOSDev"
        let expectedErrorMessage = "The request was invalid. Please check your input."
        let expectation = XCTestExpectation(description: "Should fail with bad input error")
        
        let fetcher = DetailsFetcherMock()
        
        do {
            let _ : YouTubeDetails = try await fetcher.loadDetails(for: invalidURL, to: .youtube)
        } catch let error as NetworkError {
            expectation.fulfill()
            
            switch error {
            case .badRequest(let message):
                XCTAssertEqual(message, expectedErrorMessage)
            default:
                assertionFailure("Default block should not be executed!")
            }
            
        } catch {
            Logger.error("Failed with error: \(error.localizedDescription)")
        }
        
        await fulfillment(of: [expectation], timeout: 0.001)
    }
}

// MARK: - Instagram Unit Test Cases

extension DetailsFetcherTest {
    
    func test_fetchInstagramVideoDetailsSuccessfully() async {
        let url = "instagram_response"
        let expectation = XCTestExpectation(description: "Successfully fetch video details from Instagram")
        
        await viewModel.getVideoDetails(for: url)
        expectation.fulfill()
        
        await fulfillment(of: [expectation], timeout: 0.001)
        
        XCTAssertNotNil(viewModel.details)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func test_fetchInstagramVideoDetails() async {
        let url = "instagram_response"
        
        await viewModel.getVideoDetails(for: url)
        
        let details = viewModel.details as? [InstagramDetails]
        
        XCTAssertNotNil(details)
        XCTAssertTrue(details?.count != 0)
    }
}
