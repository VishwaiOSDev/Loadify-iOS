//
//  ApiService.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/8/22.
//

import Foundation
import Photos
import UIKit

enum DownloaderStatus {
    case downloaded, failed
}

protocol DataService {
    func getVideoDetails(url: URL, completion: @escaping (VideoDetails) -> Void)
    func downloadVideo(url: URL, completion: @escaping (DownloaderStatus) -> Void)
}

// TODO: - Handle Networking (High Priority)
class ApiService: DataService {
    
    // TODO: - Handle invaild URL's
    func getVideoDetails(url: URL, completion: @escaping (VideoDetails) -> Void)  {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error Fetching data", error)
            }
            do {
                if let data = data {
                    let jsonResponse = try JSONDecoder().decode(VideoDetails.self, from: data)
                    completion(jsonResponse)
                }
            } catch {
                print("Error Decoding data", error)
            }
        }.resume()
    }
    
    // TODO: - Change the FileName to resonable name
    func downloadVideo(url: URL, completion: @escaping (DownloaderStatus) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let filePath = FileManager.default.temporaryDirectory.appendingPathComponent("\(UUID().uuidString).mp4")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error Donwloading.. \(error)")
            }
            DispatchQueue.main.async {
                do {
                    // TODO: - Video is not downloaded properly.
                    try data?.write(to: filePath)
                    PHPhotoLibrary.shared().performChanges ({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: filePath)
                    }) { completed, error in
                        if completed {
                            completion(.downloaded)
                        } else if let error = error {
                            print("Error downloading... \(error.localizedDescription)")
                            completion(.failed)
                        }
                    }
                } catch {
                    print("Error Writing file \(error)")
                    completion(.failed)
                }
            }
        }.resume()
    }
}

