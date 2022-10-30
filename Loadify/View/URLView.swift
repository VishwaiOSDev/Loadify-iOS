//
//  VideoURLView.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import SwiftUI
import LoadifyKit

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
        .showLoader(LoadifyTexts.loading, isPresented: $viewModel.showLoader)
        .showAlert(item: $viewModel.error) { error in
            AlertUI(title: error.localizedDescription, subtitle: LoadifyTexts.tryAgain.randomElement())
        }
    }
    
    @ViewBuilder
    private var headerView: some View {
        LoadifyAssets.loadifyIcon
            .frame(maxWidth: 150, maxHeight: 150)
        Text(LoadifyTexts.loadifySubTitle)
            .foregroundColor(LoadifyColors.greyText)
            .font(.inter(.regular(size: 16)))
            .multilineTextAlignment(.center)
    }
    
    private var textFieldView: some View {
        VStack(spacing: 12) {
            CustomTextField("Enter YouTube URL", text: $videoURL)
            NavigationLink(
                destination: downloadView,
                isActive: $viewModel.shouldNavigateToDownload
            ) {
                continueButton
                    .buttonStyle(CustomButtonStyle(isDisabled: videoURL.checkIsEmpty()))
            }
            .disabled(videoURL.checkIsEmpty())
        }
    }
    
    @ViewBuilder
    private var downloadView: some View {
        if let details = viewModel.details {
            DownloadView(details: details)
        }
    }
    
    private var continueButton: some View {
        Button {
            Task {
                await didTapContinue()
            }
        } label: {
            Text("Continue")
                .font(.inter(.bold(size: 18)))
        }
    }
    
    private func didTapContinue() async {
        hideKeyboard()
        await viewModel.getVideoDetails(for: videoURL)
    }
}

struct VideoURLView_Previews: PreviewProvider {
    static var previews: some View {
        let service = ApiService()
        Group {
            URLView(viewModel: URLViewModel(apiService: service))
                .previewDevice("iPhone 14 Pro Max")
                .previewDisplayName("iPhone 14 Pro Max")
            URLView(viewModel: URLViewModel(apiService: service))
                .previewDevice("iPhone SE (3rd generation)")
                .previewDisplayName("iPhone SE")
        }
        .preferredColorScheme(.dark)
    }
}
