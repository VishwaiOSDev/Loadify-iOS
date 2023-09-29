//
//  FileService.swift
//  Loadify
//
//  Created by Vishweshwaran on 09/06/22.
//

import Foundation

protocol FileServiceProtocol {
    func getTemporaryFilePath() -> URL
    func moveFile(from tempURL: URL, to path: URL) throws
}

struct FileService: FileServiceProtocol {
    
    func getTemporaryFilePath() -> URL {
        FileManager.default.temporaryDirectory.appendingPathComponent("\(UUID().uuidString).mp4")
    }
    
    func moveFile(from tempURL: URL, to path: URL) throws {
        try FileManager.default.moveItem(at: tempURL, to: path)
    }
}
