//
//  DownloaderView.swift
//  Loadify
//
//  Created by Vishweshwaran on 2023-11-22.
//

import SwiftUI
import LoadifyEngine

struct DownloaderView: View {
    
    @State private var response: LoadifyResponse
    @State var viewModel: DownloaderViewModel = DownloaderViewModel()
    
    init(response: LoadifyResponse) {
        self.response = response
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
                            urlString: response.video.thumbnail,
                            platformType: response.platform,
                            fileSize: response.video.size
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
                    
                    Spacer()
                    
                    footerView
                        .padding(.horizontal, 26)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                // TODO: - Disable the button while the video file is downloading.
                LoadifyNavigationBar(geometry.size.height, isBackButtonDisabled: false)
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
            if response.platform != .twitter {
                downloadButton(for: viewModel.downloadStatus)
            } else {
                Button(action: {}) {
                    HStack(alignment: .center) {
                        Image(systemName: "hammer")
                            .font(.system(size: 16))
                        Text("Twitter work in progress...")
                    }
                }
                .buttonStyle(CustomButtonStyle(buttonColor: LoadifyColors.errorRed))
                .disabled(true)
            }
            
            MadeWithSwiftLabel()
        }
    }
    
    @ViewBuilder
    private func downloadButton(for status: DownloadStatus) -> some View {
        switch status {
        case .none, .failed:
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
        case .downloaded:
            Button("Downloaded", systemImage: "checkmark") { }
                .buttonStyle(CustomButtonStyle(buttonColor: LoadifyColors.successGreen))
                .disabled(true)
        }
    }
    
    private func didTapDownload() async {
        await viewModel.downloadVideo(url: response.video.url)
    }
}

#Preview {
    NavigationStack {
        DownloaderView(response: LoadifyResponse.mockTwitter)
    }
}
