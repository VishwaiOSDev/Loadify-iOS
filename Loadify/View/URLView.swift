//
//  VideoURLView.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import SwiftUI

struct URLView: View {
    
    @StateObject var viewModel = URLViewModel()
    @State private var videoURL: String = ""
    
    var body: some View {
        ZStack {
            LoadifyColors.appBackground
                .edgesIgnoringSafeArea(.all)
            VStack {
                headerView
                Spacer()
                textFieldView
                    .padding(.horizontal, 16)
                Spacer()
            }
            .padding()
        }
        .navigationBarHidden(true)
        .onDisappear(perform: viewModel.onDisappear)
        .showLoader(LoadifyTexts.loading, isPresented: $viewModel.showLoader)
        .showAlert(item: $viewModel.errorMessage, content: { errorMessage -> AlertUI in
            guard let errorTitle = LoadifyTexts.tryAgain.randomElement() else {
                return AlertUI(title: errorMessage)
            }
            return AlertUI(title: errorTitle, subtitle: errorMessage)
        })
    }
    
    @ViewBuilder
    private var headerView: some View {
        LoadifyAssets.loadifyIcon
            .frame(maxWidth: 150, maxHeight: 150)
        Text(LoadifyTexts.loadifySubTitle)
            .foregroundColor(LoadifyColors.greyText)
            .font(.inter(.regular(size: 14)))
            .multilineTextAlignment(.center)
    }
    
    private var textFieldView: some View {
        VStack(spacing: 12) {
            CustomTextField("Enter YouTube or Instagram URL", text: $videoURL)
            NavigationLink(
                destination: downloaderView,
                isActive: $viewModel.shouldNavigateToDownload
            ) {
                continueButton
                    .buttonStyle(CustomButtonStyle(isDisabled: videoURL.checkIsEmpty()))
            }
            .disabled(videoURL.checkIsEmpty())
        }
    }
    
    @ViewBuilder
    private var downloaderView: some View {
        if let details = viewModel.details {
            switch viewModel.platformType {
            case .youtube:
                if let youtubeDetails = details as? VideoDetails {
                    YouTubeDownloaderView(details: youtubeDetails)
                } else {
                    fatalError("Youtube details cannot be nil")
                }
            case .instagram:
                if let instagramDetails = details as? [InstagramDetails] {
                    InstagramDownloaderView(details: instagramDetails)
                } else {
                    fatalError("Instagram details cannot be nil")
                }
            case .none:
                fatalError("Platform type not available")
            }
        }
    }
    
    private var continueButton: some View {
        Button {
            Task {
                await didTapContinue()
            }
        } label: {
            Text("Convert")
                .font(.inter(.light(size: 16)))
        }
    }
    
    private func didTapContinue() async {
        hideKeyboard()
        await viewModel.getVideoDetails(for: videoURL)
    }
}

#Preview("iPhone 15 Pro Max") {
    URLView(viewModel: URLViewModel())
        .previewDevice("iPhone 15 Pro Max")
}
