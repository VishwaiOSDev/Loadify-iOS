//
//  FileService.swift
//  Loadify
//
//  Created by Vishweshwaran on 09/06/22.
//

import Foundation
import LoggerKit

protocol FileServiceProtocol {
    func getTemporaryFilePath() -> URL
}

class FileService: FileServiceProtocol {
    
    init() {
        Logger.initialize("FileService Init - (\(Unmanaged.passUnretained(self).toOpaque()))")
    }
    
    func getTemporaryFilePath() -> URL {
        FileManager.default.temporaryDirectory.appendingPathComponent("\(UUID().uuidString).mp4")
    }
    
    deinit {
        Logger.teardown("FileService Deinit - (\(Unmanaged.passUnretained(self).toOpaque()))")
    }
}
