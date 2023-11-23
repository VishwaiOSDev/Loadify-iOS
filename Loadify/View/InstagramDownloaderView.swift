//
//  InstagramDownloaderView.swift
//  Loadify
//
//  Created by Vishweshwaran on 2023-11-22.
//

import SwiftUI

struct InstagramDownloaderView: View {
    
    @StateObject var viewModel: DownloaderViewModel = DownloaderViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var videoDetails: [InstagramDetails]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LoadifyColors.appBackground
                    .ignoresSafeArea(edges: .all)
                VStack {
                    Spacer()
                        .frame(height: geometry.size.height * 0.032)
                    VStack {
                        ImageView(urlString: videoDetails.first!.thumbnailURL) {
                            thumbnailModifier(image: LoadifyAssets.notFound)
                        } image: {
                            thumbnailModifier(image: $0)
                        } onLoading: {
                            progressView
                                .frame(minHeight: 188)
                        }
                    }
                    footerView
                        .padding(.horizontal, 26)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar { navigationBar(geometry) }
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
    
    private var progressView: some View {
        ZStack {
            ProgressView()
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
    
    private var loadifyLogo: some View {
        LoadifyAssets.loadifyHorizontal
            .resizable()
            .scaledToFit()
    }
    
    private var backButton: some View {
        Image(systemName: "chevron.backward")
            .font(Font.body.weight(.bold))
            .onTapGesture {
                presentationMode.wrappedValue.dismiss()
            }
    }
    
    private var footerView: some View {
        VStack(spacing: 16) {
            Button {
                Task {
                    await didTapDownload()
                }
            } label: {
                Text("Download")
                    .font(.inter(.light(size: 16)))
            }.buttonStyle(CustomButtonStyle())
            madeWithSwift
        }
    }
    
    private var madeWithSwift: some View {
        Text("Made with 💙 using Swift")
            .font(.inter(.regular(size: 14)))
            .foregroundColor(LoadifyColors.greyText)
    }
    
    // TODO: - Make this as generic
    @ToolbarContentBuilder
    private func navigationBar(_ geometry: GeometryProxy) -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            backButton
                .foregroundColor(LoadifyColors.blueAccent)
                .disabled(viewModel.showLoader)
        }
        ToolbarItem(placement: .principal) {
            loadifyLogo
                .frame(height: geometry.size.height * 0.050)
        }
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
    
    private func didTapDownload() async {
        await viewModel.downloadVideo(url: videoDetails.first!.videoURL, for: .instagram, with: .high)
    }
}

//#Preview {
//    NavigationView {
//        InstagramDownloaderView()
//    }
//}
