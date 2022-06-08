//
//  ApiService+Extension.swift
//  Loadify
//
//  Created by Vishweshwaran on 08/06/22.
//

import Foundation

extension ApiService {
    
    /// A generic function helps to decode data from the server
    ///
    /// For instance, if you want to decode your data to your custom struct, class or enum use `decode` method.
    ///  ````
    ///  struct UserInfo: Codeable {
    ///    var id: Int
    ///    var name: String
    ///  }
    ///  ````
    ///  Now to convert data to JSON use `decode` method as show below
    ///  ````
    ///  let decodedData = decode(data, to: UserInfo.self)
    ///  ````
    func decode<T: Codable>(_ data: Data, to type: T.Type) -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            fatalError("Failed to decode the JSON.")
        }
    }
    
    /// This function is used to create URLRequest instance
    func createUrlRequest(for url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        return urlRequest
    }
    
    /// This function handles server side errors
    func checkForServerErrors(for urlResponse: URLResponse, with data: Data) async throws {
        if let response = urlResponse as? HTTPURLResponse {
            if 400...499 ~= response.statusCode {
                let decodedErrorData = decode(data, to: ErrorModel.self)
                switch decodedErrorData.message {
                case ApiError.notValidYouTubeDomain:
                    throw DetailsError.notVaildYouTubeUrl
                default:
                    throw DetailsError.invaildApiUrl
                }
            }
        }
    }
}
