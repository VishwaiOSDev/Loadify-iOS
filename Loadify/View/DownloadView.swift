//
//  DownloadView.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/9/22.
//

import SwiftUI
import SwiftDI
import UIKit

enum Quality: String {
    case none
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var description: String {
        switch self {
        case .none: return "Select Video Quality"
        case .low: return "Low - 320p"
        case .medium: return "Medium - 720p"
        case .high: return "High - 1080p"
        }
    }
}

extension UINavigationController {
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBar.topItem?.backButtonDisplayMode = .minimal
    }
    
}

struct DownloadView<ViewModel: Downloadable>: View {
    
    var videoDetails: VideoDetails
    @State var qualities: [Quality] = [.low, .medium, .high]
    @State var selectedQuality: Quality = .none
    
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    var body: some View {
        GeometryReader { geomentry in
            ZStack {
                Loadify.Colors.app_background
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                        .frame(height: geomentry.size.height * 0.032)
                    VStack {
                        VStack {
                            ZStack(alignment: .bottomTrailing) {
                                Image(systemName: "person.fill")
                                    .data(url: videoDetails.thumbnails[videoDetails.thumbnails.count - 1].url)
                                    .frame(minHeight: 188)
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
                                Menu {
                                    Button("Low - 320p") { didTapOnQuality(.low) }
                                    Button("Medium - 720p") { didTapOnQuality(.medium) }
                                    Button("High - 1080p") { didTapOnQuality(.high) }
                                } label: {
                                    SelectView(title: selectedQuality.description)
                                }
                                .padding(.vertical, 8)
                            }
                            .padding(.horizontal, 12)
                        }
                    }
                    .background(Loadify.Colors.textfield_background)
                    .cornerRadius(10)
                    Spacer()
                    VStack(spacing: 16) {
                        Button {
                            Task {
                                await didTapDownload()
                            }
                        } label: {
                            Text("Download")
                                .bold()
                        }
                        .buttonStyle(CustomButtonStyle(isDisabled: selectedQuality == .none ? true: false))
                        .disabled(selectedQuality == .none ? true: false)
                        madeWithSwift
                    }
                }.padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image(Loadify.Images.loadify_horizontal)
                        .resizable()
                        .scaledToFit()
                        .frame(height: geomentry.size.height * 0.050)
                }
            }
        }
    }
    
    private var videoTitleView: some View {
        Text("\(videoDetails.title)")
            .foregroundColor(.white)
            .font(.title3)
            .bold()
            .lineLimit(2)
            .minimumScaleFactor(0.01)
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
    
    private func didTapOnQuality(_ quality: Quality) {
        selectedQuality = quality
    }
    
    private func didTapDownload() async {
        await viewModel.downloadVideo(with: .medium)
    }
}

struct DownloadView_Previews: PreviewProvider {
    static var previews: some View {
        let mockData = VideoDetails(
            title: "AVATAR 2 THE WAY OF WATER Trailer (4K ULTRA HD) 2022",
            description: "",
            lengthSeconds: "109",
            viewCount: "172442",
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
            likes: 172442,
            thumbnails: [
                .init(
                    url: "https://i.ytimg.com/vi/CYYtLXfquy0/hqdefault.jpg?sqp=-oaymwEcCNACELwBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&;amp;rs=AOn4CLCo3jfFz7jTmuiffAP7oetxwNgEbA",
                    width: 12,
                    height: 12
                )
            ]
        )
        Group {
            NavigationView {
                DownloadView<DownloaderViewModel>(videoDetails: mockData)
            }
            .environmentObject(DownloaderViewModel())
            .previewDevice("iPhone 13 Pro Max")
            NavigationView {
                DownloadView<DownloaderViewModel>(videoDetails: mockData)
            }
            .navigationBarTitleDisplayMode(.inline)
            .environmentObject(DownloaderViewModel())
            .previewDevice("iPhone SE (3rd generation)")
        }
    }
}
