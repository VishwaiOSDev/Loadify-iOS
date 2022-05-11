//
//  ApiService.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/8/22.
//

import Foundation

protocol DataService {
    func getVideoDetails(url: URL ,completion: @escaping (VideoDetails) -> Void)
    func getVideoDetails(from url: URL) async -> VideoDetails
}

class ApiService: DataService {
    
    func getVideoDetails(from url: URL) async -> VideoDetails {
        await withCheckedContinuation { continuation in
            getVideoDetails(url: url) { videoDetails in
                continuation.resume(returning: videoDetails)
            }
        }
    }
    
    func getVideoDetails(url: URL, completion: @escaping (VideoDetails) -> Void)  {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
            }
            let decoder = JSONDecoder()
            do {
                if let data = data {
                    let jsonResponse = try decoder.decode(VideoDetails.self, from: data)
                    completion(jsonResponse)
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}

