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
                            ForEach(details, id: \.self) { detail in
                                ImageView(urlString: detail.thumbnailURL) {
                                    thumbnailModifier(image: LoadifyAssets.notFound)
                                } image: {
                                    thumbnailModifier(image: $0)
                                } onLoading: {
                                    ZStack {
                                        ProgressView()
                                    }.frame(minHeight: 188)
                                }
                            }
                        }.tabViewStyle(.page)
                    }
                    .padding(.horizontal, 26)
                    
                    footerView
                        .padding(.horizontal, 26)
                }
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
            Button {
                Task {
                    await didTapDownload()
                }
            } label: {
                Text("Download")
                    .font(.inter(.light(size: 16)))
            }.buttonStyle(CustomButtonStyle())
            
            MadeWithSwiftLabel()
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
        await viewModel.downloadVideo(url: details.first!.videoURL, for: .instagram, with: .high)
    }
}

#Preview {
    NavigationView {
        InstagramDownloaderView(details: InstagramDetails.previews)
    }
    .preferredColorScheme(.dark)
}
