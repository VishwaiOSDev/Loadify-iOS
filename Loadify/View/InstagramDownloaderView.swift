//
//  InstagramDownloaderView.swift
//  Loadify
//
//  Created by Vishweshwaran on 2023-11-22.
//

import SwiftUI
import LoadifyEngine

struct InstagramDownloaderView: View {
    
    @State var viewModel: DownloaderViewModel
    
    init(viewModel: DownloaderViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LoadifyColors.appBackground
                    .ignoresSafeArea(edges: .all)
                
                VStack {
                    Spacer()
                        .frame(height: geometry.size.height * 0.032)
                    
                    Spacer()
                    
                    VStack {
                        ImageView(
                            urlString: viewModel.details!.video.thumbnail,
                            platformType: viewModel.details!.platform
                        ) {
                            thumbnailModifier(image: LoadifyAssets.notFound)
                        } image: {
                            thumbnailModifier(image: $0)
                        } onLoading: {
                            ZStack {
                                ProgressView()
                            }.frame(minHeight: 188)
                        }
                    }.padding(.horizontal, 26)
                    
                    DownloadBadge(downloadStatus: viewModel.downloadStatus, alignment: .center)
                    
                    Spacer()
                    
                    footerView
                        .padding(.horizontal, 26)
                }
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
        }
    }
    
    private func thumbnailModifier(image: Image) -> some View {
        image
            .resizable()
            .frame(minHeight: 188)
            .scaleImageBasedOnDevice()
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .clipped()
    }
    
    private var footerView: some View {
        VStack(spacing: 16) {
            DownloadButton(
                viewModel.errorMessage ?? "Download",
                progress: $viewModel.progress,
                showLoader: viewModel.showLoader,
                downloadFailed: viewModel.errorMessage != nil
            ) {
                Task {
                    await didTapDownload()
                }
            }
            
            MadeWithSwiftLabel()
        }
    }
    
    private func didTapDownload() async {
        await viewModel.downloadVideo(url: viewModel.details!.video.url)
    }
}

#Preview {
    NavigationStack {
        InstagramDownloaderView(viewModel: .init(details: LoadifyResponse.mockTwitter))
    }
}
