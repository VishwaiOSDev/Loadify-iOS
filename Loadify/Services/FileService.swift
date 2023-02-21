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
        Logger.initLifeCycle("FileService init", for: self)
    }
    
    func getTemporaryFilePath() -> URL {
        FileManager.default.temporaryDirectory.appendingPathComponent("\(UUID().uuidString).mp4")
    }
    
    deinit {
        Logger.deinitLifeCycle("FileService deinit", for: self)
    }
}
