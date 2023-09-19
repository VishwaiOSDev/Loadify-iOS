//
//  ApiService.swift
//  Loadify
//
//  Created by Vishweshwaran on 2023-09-17.
//

import Foundation

protocol URLSessionProtocol {
    func fetchData(for request: URLRequest) async throws -> (Data, HTTPURLResponse)
}

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
}

struct DetailFetcher {
    
    var session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func loadDetails(for youtubeURL: String) async throws -> VideoDetails {
        do {
            let request = try API.details(youtubeURL: youtubeURL).createRequest()
            let (data, httpResponse) = try await session.fetchData(for: request)
        
            guard let mimeType = httpResponse.mimeType, mimeType.contains("json") else {
                throw NetworkError.invalidResponse(message: "Invalid MIMEType")
            }
            
            return try JSONDecoder().decode(VideoDetails.self, from: data)
            
        } catch {
            throw error
        }
//
//        let request = try API.details(youtubeURL: youtubeURL).createRequest()
//        let (data, response) = try await URLSession.shared.data(for: request)
//        
//        guard let httpResponse = response as? HTTPURLResponse else {
//            throw NetworkError.invalidResponse(message: nil)
//        }
//        
//        switch httpResponse.statusCode {
//        case 200...299:
//            break
//        case 400:
//            throw NetworkError.badRequest(message: "The request was invalid. Please check your input.")
//        case 401:
//            throw NetworkError.unauthorized(message: "You are not authorized to access this resource.")
//        case 403:
//            throw NetworkError.forbidden(message: "Access to this resource is forbidden.")
//        case 404:
//            throw NetworkError.notFound(message: "The requested resource was not found.")
//        case 500...599:
//            throw NetworkError.serverError(message: "A server error occurred while processing your request.")
//        default:
//            throw NetworkError.unknownError(message: "An unknown error occurred.")
//        }
//        
//        return try JSONDecoder().decode(VideoDetails.self, from: data)
    }
}
