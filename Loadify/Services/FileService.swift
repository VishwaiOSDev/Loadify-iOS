//
//  FileService.swift
//  Loadify
//
//  Created by Vishweshwaran on 09/06/22.
//

import Foundation

protocol FileServiceProtocol {
    func getTemporaryFilePath() -> URL
}

class FileService: FileServiceProtocol {
    
    func getTemporaryFilePath() -> URL {
        FileManager.default.temporaryDirectory.appendingPathComponent("\(UUID().uuidString).mp4")
    }
}
