//
//  VideoDetails.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import Foundation

struct VideoDetails: Decodable {
    var title: String
    var description: String
    var lengthSeconds: String
    var viewCount: String
    var publishDate: String
    var ownerChannelName: String
    var videoId: String
    var author: Author
    var likes: Int
    var thumbnails: [Thumbnail]
}

struct Author: Decodable {
    var id: String
    var name: String
    var user: String
    var channelUrl: String // Coding Key
    var thumbnails: [Thumbnail]
    var subscriberCount: Int // Coding Key
}

struct Thumbnail: Decodable {
    var url: String
    var width: Int
    var height: Int
}
