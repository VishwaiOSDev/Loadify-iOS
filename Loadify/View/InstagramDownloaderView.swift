//
//  InstagramDownloaderView.swift
//  Loadify
//
//  Created by Vishweshwaran on 2023-11-22.
//

import SwiftUI

struct InstagramDownloaderView: View {
    
    @StateObject var viewModel: DownloaderViewModel = DownloaderViewModel()
    
    var details: [InstagramDetails]
    
    init(details: [InstagramDetails]) {
        self.details = details
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LoadifyColors.appBackground
                    .ignoresSafeArea(edges: .all)
                
                VStack {
                    Spacer()
                        .frame(height: geometry.size.height * 0.032)
                    
                    VStack {
                        TabView {
                            ForEach(details.prefix(3), id: \.self) { detail in
                                ImageView(urlString: detail.thumbnailURL) {
                                    thumbnailModifier(image: LoadifyAssets.notFound)
                                } image: {
                                    thumbnailModifier(image: $0)
                                } onLoading: {
                                    ZStack {
                                        ProgressView()
                                    }.frame(minHeight: 188)
                                }
                                .if(details.count > 1) {
                                    $0.padding(.horizontal, 8)
                                }
                            }
                        }.tabViewStyle(.page)
                    }.padding(.horizontal, 26)
                    
                    DownloadBadge(downloadStatus: viewModel.downloadStatus, alignment: .center)
                    
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
        await details.asyncForEach { (detail, index) in
            await viewModel.downloadVideo(url: detail.videoURL, for: .instagram, with: .high)
        }
    }
}

#Preview("iPad Pro") {
    NavigationView {
        InstagramDownloaderView(details: InstagramDetails.previews)
            .previewDevice("iPad Pro (12.9-inch) (6th generation)")
            .previewInterfaceOrientation(.landscapeRight)
    }
    .navigationViewStyle(StackNavigationViewStyle())
    .preferredColorScheme(.dark)
}

#Preview {
    NavigationView {
        InstagramDownloaderView(details: InstagramDetails.previews)
    }
}
