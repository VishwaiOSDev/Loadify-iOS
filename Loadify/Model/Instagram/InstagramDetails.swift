//
//  InstagramDetails.swift
//  Loadify
//
//  Created by Vishweshwaran on 2023-11-23.
//

import Foundation

struct InstagramDetails: Decodable, Hashable {
    
    let thumbnailURL: String
    let videoURL: String
    
    enum CodingKeys: String, CodingKey {
        case thumbnailURL = "thumbnail_link"
        case videoURL = "download_link"
    }
}

extension InstagramDetails {
    
    static let thumbnailURL = Constants.iMacURL
    
    static let previews: [InstagramDetails] = [
        InstagramDetails(thumbnailURL: thumbnailURL, videoURL: "")
    ]
}
