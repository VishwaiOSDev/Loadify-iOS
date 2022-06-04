//
//  DownloadView.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/9/22.
//

import SwiftUI

struct DownloadView<Router: Routing>: View where Router.Route == AppRoute {
    
    let router: Router
    // TODO: - Try to resolve this from Swinject
    var videoDetails: VideoDetails
    
    var body: some View {
        ZStack {
            Loadify.Colors.app_background
                .edgesIgnoringSafeArea(.all)
            constructBody(with: videoDetails)
                .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func constructBody(with details: VideoDetails) -> some View {
        VStack {
            Image(Loadify.Images.loadify_horizontal)
            Spacer()
            VStack {
                VStack {
                    Image(systemName: "person.fill")
                        .data(url: details.thumbnails[details.thumbnails.count - 1].url)
                        .scaledToFit()
                        .clipped()
                    VStack(alignment: .leading, spacing: 0) {
                        videoTitleView(for: details)
                            .padding(.vertical, 8)
                        ChannelView(
                            name: details.ownerChannelName,
                            profileImage: details.author.thumbnails[details.author.thumbnails.count - 1].url,
                            subscriberCount: details.author.subscriberCount
                        )
                        .padding(.all, 8)
                        videoInfoView(for: details)
                            .padding(.all, 8)
                    }
                    .padding(.horizontal, 12)
                }
            }
            .background(Loadify.Colors.textfield_background)
            .cornerRadius(10)
            Spacer()
            madeWithSwift
        }
    }
    
    private func videoTitleView(for details: VideoDetails) -> some View {
        Text("\(details.title)")
            .foregroundColor(.white)
            .font(.title3)
            .bold()
            .lineLimit(2)
            .minimumScaleFactor(0.5)
    }
    
    private func videoInfoView(for details: VideoDetails) -> some View {
        HStack(alignment: .center, spacing: 50) {
            InfoView(title: details.likes.shortStringRepresentation, subTitle: "Likes")
            InfoView(title: details.viewCount.commaFormater(), subTitle: "Views")
            InfoView(title: details.publishDate.dateFormatter(), subTitle: details.publishDate.dateFormatter(get: "Year"))
        }
        .frame(maxWidth: .infinity)
    }
    
    private var madeWithSwift: some View {
        Text("Made with 💙 using Swift")
            .font(.footnote)
            .foregroundColor(Loadify.Colors.grey_text)
    }
}

//struct DownloadView_Previews: PreviewProvider {
//    static var previews: some View {
//        let mockData = VideoDetails(title: "AVATAR 2 THE WAY OF WATER Trailer (4K ULTRA HD) 2022", description: "", lengthSeconds: "109", viewCount: "7123860", publishDate: "2022-05-09", ownerChannelName: "TrailerSpot", videoId: "", author: .init(id: "", name: "", user: "", channelUrl: "", thumbnails: [.init(url: "https://yt3.ggpht.com/wzh-BL3_M_uugIXZ_ANSSzzBbi_w5XnNSRl4F5DbLAxKdTfXkjgx-kWM1mChdrrMkADRQyB-nQ=s176-c-k-c0x00ffffff-no-rj", width: 120, height: 12)], subscriberCount: nil), likes: 57095, thumbnails: [.init(url: "https://i.ytimg.com/vi/CYYtLXfquy0/hqdefault.jpg?sqp=-oaymwEcCNACELwBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&;amp;rs=AOn4CLCo3jfFz7jTmuiffAP7oetxwNgEbA", width: 12, height: 12)])
//        Group {
//            DownloadView(videoDetails: mockData)
//                .previewDevice("iPhone 13 Pro Max")
//            DownloadView(videoDetails: mockData)
//                .previewDevice("iPhone SE (3rd generation)")
//        }
//    }
//}
