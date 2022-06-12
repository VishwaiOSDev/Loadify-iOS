//
//  DownloadView.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/9/22.
//

import SwiftUI
import SwiftDI
import LoadifyKit

struct DownloadView<ViewModel: Downloadable>: View {
    
    // Wrappers
    @State var selectedQuality: VideoQuality = .none
    @EnvironmentObject var viewModel: ViewModel
    
    // Properties
    var details: VideoDetails
    
    var body: some View {
        GeometryReader { geomentry in
            ZStack {
                Colors.app_background
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                        .frame(height: geomentry.size.height * 0.032)
                    VStack {
                        VStack {
                            thumbnailView
                            videoContentView
                        }
                    }
                    .cardView(color: Colors.textfield_background)
                    Spacer()
                    footerView
                }
                .padding()
            }
            .alert(isPresented: $viewModel.showSettingsAlert, content: { permissionAlert })
            .showLoader(Texts.downloading, isPresented: $viewModel.showLoader)
            .showAlert(item: $viewModel.downloadError) { error in
                AlertUI(title: error.localizedDescription, subtitle: Texts.try_again.randomElement())
            }
            .showAlert(isPresented: $viewModel.isDownloaded) {
                AlertUI(title: Texts.downloaded_title, subtitle: Texts.downloaded_subtitle, alertType: .success)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image(Images.loadify_horizontal)
                        .resizable()
                        .scaledToFit()
                        .frame(height: geomentry.size.height * 0.050)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var thumbnailView: some View {
        ZStack(alignment: .bottomTrailing) {
            Image("not_found")
                .data(url: details.thumbnails[details.thumbnails.count - 1].url)
                .frame(minHeight: 188)
                .scaledToFit()
                .clipped()
            durationView
                .offset(x: -5, y: -5)
        }
    }
    
    private var durationView: some View {
        Text(details.lengthSeconds.getDuration)
            .font(.caption2)
            .foregroundColor(.white)
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .background(Color.black.opacity(0.6).cornerRadius(4))
    }
    
    private var videoContentView: some View {
        VStack(alignment: .leading, spacing: 0) {
            videoTitleView
                .padding(.vertical, 8)
            ChannelView(
                name: details.ownerChannelName,
                profileImage: details.author.thumbnails[details.author.thumbnails.count - 1].url,
                subscriberCount: details.author.subscriberCount
            )
            .padding(.all, 8)
            videoInfoView
                .padding(.all, 8)
            menuView
                .padding(.vertical, 8)
        }
        .padding(.horizontal, 12)
    }
    
    private var menuView: some View {
        Menu {
            Button(VideoQuality.high.description) { didTapOnQuality(.high) }
            Button(VideoQuality.medium.description) { didTapOnQuality(.medium) }
            Button(VideoQuality.low.description) { didTapOnQuality(.low) }
        } label: {
            MenuButton(title: selectedQuality.description)
        }
    }
    
    private var videoTitleView: some View {
        Text(details.title)
            .foregroundColor(.white)
            .font(.title3)
            .bold()
            .lineLimit(2)
    }
    
    private var videoInfoView: some View {
        HStack(alignment: .center, spacing: 50) {
            InfoView(title: details.likes.toUnits, subTitle: "Likes")
            InfoView(title: details.viewCount.format, subTitle: "Views")
            InfoView(title: details.publishDate.dateFormatter(), subTitle: details.publishDate.dateFormatter(get: "Year"))
        }
        .frame(maxWidth: .infinity)
    }
    
    private var footerView: some View {
        VStack(spacing: 16) {
            Button {
                Task {
                    await didTapDownload(quality: selectedQuality)
                }
            } label: {
                Text("Download")
                    .bold()
            }
            .buttonStyle(CustomButtonStyle(isDisabled: selectedQuality == .none ? true: false))
            .disabled(selectedQuality == .none ? true: false)
            madeWithSwift
        }
    }
    
    private var madeWithSwift: some View {
        Text("Made with 💙 using Swift")
            .font(.footnote)
            .foregroundColor(Colors.grey_text)
    }
    
    private var permissionAlert: Alert {
        Alert(
            title: Text(Texts.photos_access_title),
            message: Text(Texts.photos_access_subtitle),
            primaryButton: .default(Text("Settings"), action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }),
            secondaryButton: .default(Text("Cancel"))
        )
    }
    
    private func didTapOnQuality(_ quality: VideoQuality) {
        selectedQuality = quality
    }
    
    private func didTapDownload(quality: VideoQuality) async {
        await viewModel.downloadVideo(with: quality)
    }
}

struct DownloadView_Previews: PreviewProvider {
    static var previews: some View {
        let mockData = VideoDetails(
            title: "AVATAR 2 THE #WAY OF WATER Trailer (4K ULTRA HD) 2022",
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
                        url: "1https://yt3.ggpht.com/wzh-BL3_M_uugIXZ_ANSSzzBbi_w5XnNSRl4F5DbLAxKdTfXkjgx-kWM1mChdrrMkADRQyB-nQ=s176-c-k-c0x00ffffff-no-rj",
                        width: 120,
                        height: 12
                    )
                ],
                subscriberCount: nil
            ),
            likes: 172442,
            thumbnails: [
                .init(
                    url: "1https://i.ytimg.com/vi/CYYtLXfquy0/hqdefault.jpg?sqp=-oaymwEcCNACELwBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&;amp;rs=AOn4CLCo3jfFz7jTmuiffAP7oetxwNgEbA",
                    width: 12,
                    height: 12
                )
            ]
        )
        Group {
            NavigationView {
                DownloadView<DownloaderViewModel>(details: mockData)
            }
            .environmentObject(DownloaderViewModel())
            .previewDevice("iPhone 13 Pro Max")
            NavigationView {
                DownloadView<DownloaderViewModel>(details: mockData)
            }
            .navigationBarTitleDisplayMode(.inline)
            .environmentObject(DownloaderViewModel())
            .previewDevice("iPhone SE (3rd generation)")
        }
    }
}
