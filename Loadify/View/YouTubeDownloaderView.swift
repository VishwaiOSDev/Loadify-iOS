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
                
//                VStack(alignment: .leading, spacing: 4) {
//                    Text("Downloading...")
//                        .font(.inter(.bold(size: 20)))
//                    
//                    Text("Please keep the app open. This may take a moment.")
//                        .font(.inter(.medium(size: 12)))
//                        .foregroundColor(.white)
//                        .opacity(0.5)
//                    
//                    ProgressView(value: 0.45)
//                        .progressViewStyle(LinearProgressViewStyle(tint: LoadifyColors.blueAccent))
//                        .frame(height: 8)
//                        .scaleEffect(x: 1, y: 2, anchor: .center)
//                        .clipShape(RoundedRectangle(cornerRadius: 6))
//                        .padding(.top, 14)
//                        .padding(.bottom, 4)
//                }
//                .padding(.all, 16)
//                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
//                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                LoadifyNavigationBar(
                    geometry.size.height,
                    isBackButtonDisabled: viewModel.showLoader
                )
            }
            .permissionAlert(isPresented: $viewModel.showSettingsAlert)
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
                profileImage: details.author.thumbnails[details.author.thumbnails.count - 1].url,
                subscriberCount: details.author.subscriberCount.toUnits
            ).padding(.all, 8)
            
            videoInfoView
                .padding(.all, 8)
            
            menuView
                .padding(.vertical, 8)
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
            DownloadButton(progress: $viewModel.progress, isDisabled: isDownloadButtonDisabled) {
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
        await viewModel.downloadVideo(url: details.videoUrl, for: .youtube, with: quality)
    }
}

#Preview("iPad Pro") {
    NavigationView {
        YouTubeDownloaderView(details: .previews)
            .previewDevice("iPad Pro (12.9-inch) (6th generation)")
            .previewInterfaceOrientation(.landscapeRight)
    }
    .preferredColorScheme(.dark)
    .navigationViewStyle(StackNavigationViewStyle())
}

