//
//  VideoDetails.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import Foundation

struct VideoDetails: Codable {
    var title: String
    var lengthSeconds: String
    var viewCount: String
    var publishDate: String
    var ownerChannelName: String
    var videoId: String
    var author: Author
    var likes: Int
    var thumbnails: [Thumbnail]
}

struct Author: Codable {
    var id: String
    var name: String
    var user: String
    var channelUrl: String
    var thumbnails: [Thumbnail]
    var subscriberCount: Int?
    
    private enum CodingKeys: String, CodingKey {
        case channelUrl = "channel_url"
        case subscriberCount = "subscriber_count"
        
        case id
        case name
        case user
        case thumbnails
    }
}

struct Thumbnail: Codable {
    var url: String
    var width: Int
    var height: Int
}

struct ErrorModel: Codable {
    var message: String
}
