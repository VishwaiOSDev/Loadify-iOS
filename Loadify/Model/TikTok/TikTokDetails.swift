//
//  TikTokDetails.swift
//  Loadify
//
//  Created by Vishweshwaran on 2023-12-16.
//

import Foundation

struct TikTokDetails: Decodable {
    let status: String
    let result: ResultDetails
}

struct ResultDetails: Decodable {
    let type: String
    let description: String
    let createTime: Int
    let author: Author
    let statistics: Statistics
    let video: [URL]
    let cover: [URL]
    let dynamicCover: [URL]
    let originCover: [URL]
}

struct Author: Decodable {
    let username: String
    let avatarThumb: [URL]
}

struct Statistics: Decodable {
    let likeCount: Int
    let playCount: Int
}
