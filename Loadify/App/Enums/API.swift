//
//  Endpoint.swift
//  Loadify
//
//  Created by Vishweshwaran on 11/09/22.
//

import Foundation

enum API {
    case details(youtubeURL: String)
    case download(youtubeURL: String, quality: VideoQuality)
}

extension API: NetworkRequestable {
    
    var host: String {
        "loadify.madrasvalley.com"
    }
    
    var path: String {
        switch self {
        case .details:
            return "/api/yt/details"
        case .download:
            return "/api/yt/download/video/mp4"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .details, .download:
            return .get
        }
    }
    
    var queryParameter: [String : AnyHashable]? {
        switch self {
        case .details(let url):
            return ["url": url]
        case .download(let url, let quality):
            return ["url": url, "video_quality": quality.rawValue]
        }
    }
    
    /// Configuration for `localhost`
    var shouldRunLocal: Bool { false }
    
    var port: Int? { 3200 }
}

enum HTTPMethod: String, Equatable {
    case delete = "DELETE"
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
}

protocol NetworkRequestable {
    var url: URL { get throws }
    var host: String { get }
    var path: String { get }
    var port: Int? { get }
    var isSecure: Bool { get }
    var shouldRunLocal: Bool { get }
    var httpMethod: HTTPMethod { get }
    var queryParameter: [String: AnyHashable]? { get }
}

/// Protocol Extension for constructing `URL`
extension NetworkRequestable {
    
    /// Computed property to construct the URL based on the configuration.
    var url: URL {
        get throws {
            var urlComponent = URLComponents()
            urlComponent.path = path
            urlComponent.port = shouldRunLocal ? port : nil
            urlComponent.host = shouldRunLocal ? "localhost" : host
            urlComponent.scheme = isSecure && !shouldRunLocal ? "https" : "http"
            guard let url = urlComponent.url else { throw URLError(.badURL) }
            return url.addQueryParamIfNeeded(queryParameter)
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

extension URL {
    
    func addQueryParamIfNeeded(_ queryParams: [String: Any]?) -> URL {
        guard let queryParams = queryParams,
              var urlComponents = URLComponents(string: absoluteString) else {
            return absoluteURL
        }
        let queryItems = queryParams.map { URLQueryItem(name: $0, value: "\($1)") }
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
