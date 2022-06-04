//
//  DownloadView.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/9/22.
//

import SwiftUI
import SwiftDI

struct DownloadView<Router: Routing>: View where Router.Route == AppRoute {
    
    let router: Router
    // TODO: - Try to resolve this from Swinject
    var videoDetails: VideoDetails
    @ObservedInject var downloaderViewModel: DownloderViewModel
    
    var body: some View {
        ZStack {
            Loadify.Colors.app_background
                .edgesIgnoringSafeArea(.all)
            constructBody
                .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private var constructBody: some View {
        VStack {
            Image(Loadify.Images.loadify_horizontal)
            Spacer()
            VStack {
                VStack {
                    ZStack(alignment: .bottomTrailing) {
                        Image(systemName: "person.fill")
                            .data(url: videoDetails.thumbnails[videoDetails.thumbnails.count - 1].url)
                            .scaledToFit()
                            .clipped()
                        durationView
                            .offset(x: -5, y: -5)
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        videoTitleView
                            .padding(.vertical, 8)
                        ChannelView(
                            name: videoDetails.ownerChannelName,
                            profileImage: videoDetails.author.thumbnails[videoDetails.author.thumbnails.count - 1].url,
                            subscriberCount: videoDetails.author.subscriberCount
                        )
                        .padding(.all, 8)
                        videoInfoView
                            .padding(.all, 8)
                        Button(action: didTapDownload) {
                            Text("Download")
                                .bold()
                        }
                        .buttonStyle(CustomButtonStyle())
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
    
    private var videoTitleView: some View {
        Text("\(videoDetails.title)")
            .foregroundColor(.white)
            .font(.title3)
            .bold()
            .lineLimit(2)
            .minimumScaleFactor(0.5)
    }
    
    private var durationView: some View {
        Text(videoDetails.lengthSeconds.getDuration())
            .font(.caption2)
            .foregroundColor(.white)
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .background(Color.black.opacity(0.6).cornerRadius(4))
    }
    
    private var videoInfoView: some View {
        HStack(alignment: .center, spacing: 50) {
            InfoView(title: videoDetails.likes.shortStringRepresentation, subTitle: "Likes")
            InfoView(title: videoDetails.viewCount.commaFormater(), subTitle: "Views")
            InfoView(title: videoDetails.publishDate.dateFormatter(), subTitle: videoDetails.publishDate.dateFormatter(get: "Year"))
        }
        .frame(maxWidth: .infinity)
    }
    
    private var madeWithSwift: some View {
        Text("Made with 💙 using Swift")
            .font(.footnote)
            .foregroundColor(Loadify.Colors.grey_text)
    }
    
    private func didTapDownload() {
        downloaderViewModel.downloadVideo(with: .medium)
    }
}

struct DownloadView_Previews: PreviewProvider {
    static var previews: some View {
        let mockData = VideoDetails(
            title: "AVATAR 2 THE WAY OF WATER Trailer (4K ULTRA HD) 2022",
            description: "",
            lengthSeconds: "109",
            viewCount: "7123860",
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
                        url: "https://yt3.ggpht.com/wzh-BL3_M_uugIXZ_ANSSzzBbi_w5XnNSRl4F5DbLAxKdTfXkjgx-kWM1mChdrrMkADRQyB-nQ=s176-c-k-c0x00ffffff-no-rj",
                        width: 120,
                        height: 12
                    )
                ],
                subscriberCount: nil
            ),
            likes: 57095,
            thumbnails: [
                .init(
                    url: "https://i.ytimg.com/vi/CYYtLXfquy0/hqdefault.jpg?sqp=-oaymwEcCNACELwBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&;amp;rs=AOn4CLCo3jfFz7jTmuiffAP7oetxwNgEbA",
                    width: 12,
                    height: 12
                )
            ]
        )
        Group {
            DownloadView(router: AppRouter(downloaderViewModel: URLViewModel()), videoDetails: mockData)
                .previewDevice("iPhone 13 Pro Max")
            DownloadView(router: AppRouter(downloaderViewModel: URLViewModel()), videoDetails: mockData)
                .previewDevice("iPhone SE (3rd generation)")
        }
    }
}
