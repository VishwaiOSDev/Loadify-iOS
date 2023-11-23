//
//  VideoDetails.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import Foundation

struct VideoDetails: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case videoUrl = "video_url"
        case title, lengthSeconds, viewCount, publishDate
        case ownerChannelName, videoId, author, likes, thumbnails
    }
    
    var title: String
    var lengthSeconds: String
    var viewCount: String
    var publishDate: String
    var ownerChannelName: String
    var videoId: String
    var author: Author
    var likes: Int?
    var videoUrl: String
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
        case id, name, user, thumbnails
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

struct InstagramDetails: Codable, Hashable {
    
    let thumbnailURL: String
    let videoURL: String
    
    enum CodingKeys: String, CodingKey {
        case thumbnailURL = "thumbnail_link"
        case videoURL = "download_link"
    }
}

extension VideoDetails {
    
    static let channelThumbnail = "1https://yt3.ggpht.com/wzh-BL3_M_uugIXZ_ANSSzzBbi_w5XnNSRl4F5DbLAxKdTfXkjgx-kWM1mChdrrMkADRQyB-nQ=s176-c-k-c0x00ffffff-no-rj"
    static let videoThumbnail = "1https://i.ytimg.com/vi/CYYtLXfquy0/hqdefault.jpg?sqp=-oaymwEcCNACELwBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&;amp;rs=AOn4CLCo3jfFz7jTmuiffAP7oetxwNgEbA"
    
    static let previews: VideoDetails = VideoDetails(
        title: "AVATAR 2 THE #WAY OF WATER Trailer (4K ULTRA HD) 2022",
        lengthSeconds: "109",
        viewCount: "7876945312 ",
        publishDate: "2022-05-09",
        ownerChannelName: "TrailerSpot",
        videoId: "",
        author: .init(
            id: "",
            name: "",
            user: "",
            channelUrl: "",
            thumbnails: [
                .init(
                    url: channelThumbnail,
                    width: 120,
                    height: 12
                )
            ],
            subscriberCount: nil
        ),
        likes: 172442,
        videoUrl: "https://www.youtube.com/watch?v=66XwG1CLHuU",
        thumbnails: [
            .init(
                url: videoThumbnail,
                width: 12,
                height: 12
            )
        ]
    )
}

extension InstagramDetails {
    
    static let thumbnailURL = "https://igcdn.xyz/?token=fa3988c3bdade097ee51a58c8c40437ae447dd17a04819bae63f50623a1b5de2&time=1700717738&file=https%3a%2f%2fscontent.cdninstagram.com%2fv%2ft51.2885-15%2f395265733_364940032536528_5099172351027615466_n.jpg%3fstp%3ddst-jpg_e15%26_nc_ht%3dscontent.cdninstagram.com%26_nc_cat%3d100%26_nc_ohc%3dHC4wuyQisrUAX-2UXkJ%26edm%3dAPs17CUBAAAA%26ccb%3d7-5%26oh%3d00_AfAm5gncIVjqpUJe8F8w_XHRGzEXyQVGtWg3qQk7BpQDeQ%26oe%3d65606889%26_nc_sid%3d10d13b"
    
    static let previews: [InstagramDetails] = [
        InstagramDetails(thumbnailURL: thumbnailURL, videoURL: "")
    ]
}
