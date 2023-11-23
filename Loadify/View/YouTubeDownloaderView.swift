//
//  DownloadView.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/9/22.
//

import SwiftUI

struct YouTubeDownloaderView: View {
    
    @StateObject var viewModel: DownloaderViewModel = DownloaderViewModel()
    @State private var selectedQuality: VideoQuality = .none
    
    var details: VideoDetails
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LoadifyColors.appBackground
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                        .frame(height: geometry.size.height * 0.032)
                    
                    VStack {
                        VStack {
                            thumbnailView
                            videoContentView
                        }
                    }
                    .cardView(color: LoadifyColors.textfieldBackground)
                    
                    if !Device.iPad {
                        Spacer()
                    }
                    
                    footerView
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                LoadifyNavigationBar(geometry.size.height, isBackButtonDisabled: viewModel.showLoader)
            }
            .alert(isPresented: $viewModel.showSettingsAlert, content: { permissionAlert })
            .showLoader(LoadifyTexts.downloading, isPresented: $viewModel.showLoader)
            .showAlert(item: $viewModel.downloadError) {
                AlertUI(
                    title: $0.localizedDescription,
                    subtitle: LoadifyTexts.tryAgain.randomElement()
                )
            }
            .showAlert(isPresented: $viewModel.isDownloaded) {
                AlertUI(
                    title: LoadifyTexts.downloadedTitle,
                    subtitle: LoadifyTexts.downloadedSubtitle,
                    alertType: .success
                )
            }
        }
    }
    
    @ViewBuilder
    private var thumbnailView: some View {
        ZStack(alignment: .bottomTrailing) {
            ImageView(urlString: details.thumbnails[details.thumbnails.count - 1].url) {
                thumbnailModifier(image: LoadifyAssets.notFound)
            } image: {
                thumbnailModifier(image: $0)
            } onLoading: {
                progressView
                    .frame(minHeight: 188)
            }.frame(maxWidth: Loadify.maxWidth)
            durationView
                .offset(x: -5, y: -5)
        }
    }
    
    private func thumbnailModifier(image: Image) -> some View {
        image
            .resizable()
            .frame(minHeight: 188)
            .scaleImageBasedOnDevice()
            .clipped()
    }
    
    private var progressView: some View {
        ZStack {
            ProgressView()
        }
    }
    
    private var durationView: some View {
        Text(details.lengthSeconds.getDuration)
            .font(.inter(.regular(size: 10)))
            .foregroundColor(.white)
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .background(Color.black.opacity(0.6).cornerRadius(4))
    }
    
    private var videoContentView: some View {
        VStack(alignment: .leading, spacing: 0) {
            downloadedBadge
                .padding(.top, 2)
            videoTitleView
                .padding(.vertical, 8)
            ChannelView(
                name: details.ownerChannelName,
                profileImage: details.author.thumbnails[details.author.thumbnails.count - 1].url,
                subscriberCount: details.author.subscriberCount.toUnits
            )
            .padding(.all, 8)
            videoInfoView
                .padding(.all, 8)
            menuView
                .padding(.vertical, 8)
        }
        .padding(.horizontal, 12)
    }
    
    @ViewBuilder
    private var downloadedBadge: some View {
        if viewModel.downloadStatus == .downloaded || viewModel.downloadStatus == .failed {
            HStack(spacing: 4) {
                Image(systemName: "arrow.down.circle.fill")
                Text(viewModel.downloadStatus == .downloaded ? "Downloaded" : "Failed")
                    .font(.inter(.bold(size: 14)))
                    .padding(2)
                    .cornerRadius(4)
            }
            .padding(.all, 4)
            .foregroundColor(.white)
            .background(badgeColor)
            .cornerRadius(4)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var badgeColor: Color {
        let status = viewModel.downloadStatus
        return status == .downloaded ? LoadifyColors.successGreenGradient : LoadifyColors.errorRed
    }
    
    private var videoTitleView: some View {
        Text(details.title)
            .foregroundColor(.white)
            .font(.inter(.bold(size: 18)))
            .lineLimit(2)
    }
    
    private var videoInfoView: some View {
        ZStack(alignment: .center) {
            InfoView(title: details.likes.toUnits, subTitle: "Likes")
                .frame(maxWidth: .infinity, alignment: .leading)
            InfoView(title: details.viewCount.format, subTitle: "Views")
                .frame(maxWidth: .infinity, alignment: .center)
            InfoView(
                title: details.publishDate.formattedDate(),
                subTitle: details.publishDate.formattedDate(.year)
            ).frame(maxWidth: .infinity, alignment: .trailing)
        }
        .frame(maxWidth: .infinity)
        .padding(.all, 4)
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
    
    private var footerView: some View {
        VStack(spacing: 16) {
            Button {
                Task {
                    await didTapDownload(quality: selectedQuality)
                }
            } label: {
                Text("Download")
                    .font(.inter(.light(size: 16)))
            }
            .buttonStyle(CustomButtonStyle(isDisabled: selectedQuality == .none ? true: false))
            .disabled(selectedQuality == .none ? true: false)
            madeWithSwift
        }
    }
    
    private var madeWithSwift: some View {
        Text("Made with 💙 using Swift")
            .font(.inter(.regular(size: 14)))
            .foregroundColor(LoadifyColors.greyText)
    }
    
    private var permissionAlert: Alert {
        Alert(
            title: Text(LoadifyTexts.photosAccessTitle),
            message: Text(LoadifyTexts.photosAccessSubtitle),
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
        await viewModel.downloadVideo(url: details.videoUrl, for: .youtube, with: quality)
    }
}

extension View {
    
    @ViewBuilder
    func scaleImageBasedOnDevice() -> some View {
        if Device.iPad {
            self.scaledToFill()
        } else {
            self.scaledToFit()
        }
    }
}

#Preview("iPad Pro") {
    NavigationView {
        YouTubeDownloaderView(details: .previews)
            .previewDevice("iPad Pro (12.9-inch) (6th generation)")
            .previewInterfaceOrientation(.landscapeRight)
    }
    .navigationViewStyle(StackNavigationViewStyle())
}
