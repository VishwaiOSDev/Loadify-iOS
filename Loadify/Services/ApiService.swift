//
//  ApiService.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/8/22.
//

import Foundation

protocol DataService {
    func getVideoDetails(from url: URL)
}

class ApiService: DataService {
    
    func getVideoDetails(from url: URL) {
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
                    print(jsonResponse)
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}

