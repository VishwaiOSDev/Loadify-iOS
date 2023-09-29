//
//  URLSession+Extension.swift
//  Loadify
//
//  Created by Vishweshwaran on 2023-09-26.
//

import Foundation

extension URLSession: URLSessionProtocol {
    
    func fetchData(for request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse(message: nil)
        }
        
        switch httpResponse.statusCode {
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
        
        return (data, httpResponse)
    }
    
    func downloadData(for request: URLRequest) async throws -> (URL, HTTPURLResponse) {
        let (data, response) = try await download(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse(message: nil)
        }
        
        switch httpResponse.statusCode {
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
        
        return (data, httpResponse)
    }
}
