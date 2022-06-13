//
//  VideoDetailsTest.swift
//  LoadifyTests
//
//  Created by Vishweshwaran on 13/06/22.
//

import XCTest
@testable import Loadify

// TODO: - Rearchitect the DownloadViewModel to make it Testable
class VideoDetailsTest: XCTestCase {
    
    var downloaderViewModel: DownloaderViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        downloaderViewModel = DownloaderViewModel()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        downloaderViewModel = nil
    }
    
    func testFetchVideoDetailsSuccessfully() async throws {
        
    }
}
