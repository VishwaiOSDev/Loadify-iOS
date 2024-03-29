//
//  URLSession+Extension.swift
//  Loadify
//
//  Created by Vishweshwaran on 2023-09-26.
//

import Foundation

extension URLSession: URLSessionProtocol {
    
    func fetch(for request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await data(for: request)
        
        let httpResponse = try response.handleStatusCodeAndReturnHTTPResponse()
        
        return (data, httpResponse)
    }
    
    func download(for request: URLRequest) {
        let task = downloadTask(with: request)
        task.resume()
    }
    
    func finishAndInvalidate() {
        self.finishTasksAndInvalidate()
    }
}

extension URLResponse {
    
    var httpResponse: HTTPURLResponse {
        get throws {
            guard let httpResponse = self as? HTTPURLResponse else {
                throw NetworkError.unknownError(message: nil)
            }
            
            return httpResponse
        }
    }
    
    func handleStatusCodeAndReturnHTTPResponse() throws -> HTTPURLResponse {
        let response = try httpResponse
        
        switch response.statusCode {
        case 200...299:
            break
        case 400:
            throw NetworkError.badRequest(message: "The request was invalid. Please check your input.")
        case 401:
            throw NetworkError.unauthorized(message: "You are not authorized to access this resource.")
        case 403:
            throw NetworkError.forbidden(message: "Access to this resource is forbidden.")
        case 404:
            throw NetworkError.notFound(message: "The requested resource was not found.")
        case 500...599:
            throw NetworkError.serverError(message: "A server error occurred while processing your request.")
        default:
            throw NetworkError.unknownError(message: "An unknown error occurred.")
        }
        
        return response
    }
}
