//
//  DownloadView.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/9/22.
//

import SwiftUI
import LoadifyEngine

@available(*, deprecated, message: "YouTubeDownloaderView is depreciation. Please use DownloaderView instead.")
struct YouTubeDownloaderView: View {
    
    @State var viewModel: DownloaderViewModel = DownloaderViewModel()
    @State private var selectedQuality: VideoQuality = .none
    
    var details: YouTubeDetails
    
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
                                .padding(.horizontal, 12)
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
                let shouldDisable = (viewModel.showLoader || viewModel.isDownloading)
                LoadifyNavigationBar(geometry.size.height, isBackButtonDisabled: shouldDisable)
            }
            .permissionAlert(isPresented: $viewModel.showSettingsAlert)
            .showAlert(item: $viewModel.downloadError) {
                AlertUI(
                    title: $0.localizedDescription,
                    subtitle: LoadifyTexts.tryAgain.randomElement()
                )
            }
            .onChange(of: selectedQuality) { _ in
                withAnimation(.linear(duration: 0.4)) {
                    viewModel.errorMessage = nil
                }
            }
        }
    }
    
    @ViewBuilder
    private var thumbnailView: some View {
        ZStack(alignment: .bottomTrailing) {
            ImageView(urlString: details.thumbnails.last!.url) {
                thumbnailModifier(image: LoadifyAssets.notFound)
            } image: {
                thumbnailModifier(image: $0)
            } onLoading: {
                ZStack {
                    ProgressView()
                }.frame(minHeight: 188)
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
            DownloadBadge(downloadStatus: viewModel.downloadStatus)
                .padding(.top, 2)
            
            videoTitleView
                .padding(.vertical, 8)
            
            ChannelView(
                name: details.ownerChannelName,
                profileImage: details.author.thumbnails.last!.url,
                subscriberCount: details.author.subscriberCount.toUnits
            ).padding(.all, 8)
            
            videoInfoView
                .padding(.all, 8)
            
            menuView
                .padding(.vertical, 8)
                .allowsHitTesting(!viewModel.showLoader && !viewModel.isDownloading)
        }
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
            ForEach(VideoQuality.allCases, id: \.self) { quality in
                Button(quality.description) {
                    didTapOnQuality(quality)
                }
            }
        } label: {
            MenuButton(title: selectedQuality.description)
        }
    }
    
    private var footerView: some View {
        let isDownloadButtonDisabled = selectedQuality == .none
        
        return VStack(spacing: 16) {
            DownloadButton(
                viewModel.errorMessage ?? "Download",
                progress: $viewModel.progress,
                showLoader: viewModel.showLoader,
                isDisabled: isDownloadButtonDisabled,
                downloadFailed: viewModel.errorMessage != nil
            ) {
                Task {
                    await didTapDownload(quality: selectedQuality)
                }
            }
            
            MadeWithSwiftLabel()
        }
    }
    
    private func didTapOnQuality(_ quality: VideoQuality) {
        selectedQuality = quality
    }
    
    private func didTapDownload(quality: VideoQuality) async {
        await viewModel.downloadVideo(url: details.videoUrl)
    }
}

#Preview("iPad Pro") {
    NavigationView {
        YouTubeDownloaderView(details: .previews)
    }
    .preferredColorScheme(.dark)
    .navigationViewStyle(StackNavigationViewStyle())
}
