//
//  NetworkRequestable.swift
//  Loadify
//
//  Created by Vishweshwaran on 2023-09-25.
//

import Foundation

enum HTTPMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
}

protocol NetworkRequestable {
    var host: String { get }
    var path: String { get }
    var port: Int? { get }
    var isSecure: Bool { get }
    var shouldRunLocal: Bool { get }
    var httpMethod: HTTPMethod { get }
    var queryParameters: [String: AnyHashable]? { get }
}

/// Protocol Extension for constructing `URL`
extension NetworkRequestable {
    
    /// Computed property to construct the URL based on the configuration.
    var url: URL {
        get throws {
            var urlComponents = URLComponents()
            urlComponents.path = path
            urlComponents.port = shouldRunLocal ? port : nil
            urlComponents.host = shouldRunLocal ? "localhost" : host
            urlComponents.scheme = isSecure && !shouldRunLocal ? "https" : "http"
            
            guard let url = urlComponents.url else {
                throw URLError(.badURL)
            }
            
            return url.addQueryParametersIfNeeded(queryParameters)
        }
    }
    
    /// Default implementation for port.
    var port: Int? { nil }
    
    /// Computed property to determine whether the connection should be secure.
    var isSecure: Bool {
        shouldRunLocal ? false : true
    }
    
    /// Default implementation for determining whether to run locally.
    var shouldRunLocal: Bool { false }
    
    func createRequest() throws -> URLRequest {
        var request = URLRequest(url: try self.url)
        request.httpMethod = self.httpMethod.rawValue
        return request
    }
}

fileprivate extension URL {
    func addQueryParametersIfNeeded(_ queryParameters: [String: AnyHashable]?) -> URL {
        guard let queryParameters = queryParameters,
              var urlComponents = URLComponents(string: absoluteString) else {
            return absoluteURL
        }
        let queryItems = queryParameters.map { URLQueryItem(name: $0, value: "\($1)") }
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
}

enum NetworkError: Error {
    case invalidResponse(message: String?)
    case badRequest(message: String?)
    case unauthorized(message: String?)
    case forbidden(message: String?)
    case notFound(message: String?)
    case serverError(message: String?)
    case unknownError(message: String?)
}
