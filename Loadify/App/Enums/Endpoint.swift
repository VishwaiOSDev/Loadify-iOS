//
//  Endpoint.swift
//  Loadify
//
//  Created by Vishweshwaran on 11/09/22.
//

import Foundation
import NetworkKit

enum Endpoint {
    
    case details(youtubeURL: String)
    
    var host: String {
        "api.loadify.app"
    }
}

extension Endpoint: NetworkRequestable {
    
    var url: URL {
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = host
        urlComponent.path = path
        return urlComponent.url!
    }
    
    var path: String {
        switch self {
        case .details:
            return "/api/yt/details"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .details:
            return HTTPMethod.get
        }
    }
    
    var queryParameter: [String : Any]? {
        switch self {
        case .details(let url):
            return ["url": url]
        }
    }
}
