//
//  VideoURLView.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import SwiftUI
import SwiftDI
import LoadifyKit

struct URLView<ViewModel: Detailable>: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @EnvironmentObject var alertAction: AlertViewAction
    
    var body: some View {
        ZStack {
            Loadify.Colors.app_background
                .edgesIgnoringSafeArea(.all)
            VStack {
                headerView
                Spacer()
                textFieldView
                    .padding(.horizontal, 16)
                Spacer()
                termsOfService
            }
            .padding()
            loaderView
        }
        .navigationBarHidden(true)
    }
    
    @ViewBuilder
    private var headerView: some View {
        Image(Loadify.Images.loadify_icon)
            .frame(maxWidth: 150, maxHeight: 150)
        Text("We are the best Audio and Video downloader \n app ever")
            .foregroundColor(Loadify.Colors.grey_text)
            .font(.subheadline)
            .multilineTextAlignment(.center)
    }
    
    private var textFieldView: some View {
        VStack(spacing: 12) {
            CustomTextField("Enter YouTube URL", text: $viewModel.url)
            NavigationLink(
                destination: downloadView,
                isActive: $viewModel.shouldNavigateToDownload
            ) {
                Button(action: didTapContinue) {
                    Text("Continue")
                        .bold()
                }.buttonStyle(CustomButtonStyle())
            }
        }
    }
    
    private var termsOfService: some View {
        ZStack {
            Text("By continuing, you agree to our ") +
            Text("Privacy Policy")
                .bold()
                .foregroundColor(Loadify.Colors.blue_accent) +
            Text(" and \nour ") +
            Text("Terms of Service")
                .bold()
                .foregroundColor(Loadify.Colors.blue_accent)
        }
        .foregroundColor(Loadify.Colors.grey_text)
        .font(.footnote)
    }
    
    @ViewBuilder
    private var loaderView: some View {
        if viewModel.showProgessView {
            LoaderView(title: "Fetching Details...")
        }
    }
    
    private func didTapContinue() {
        if viewModel.url.isEmpty {
            alertAction.showAlert(
                title: "Error",
                subTitle: "URL cannot be empty",
                options: .init(alertType: .error, style: .vertical)
            )
        } else {
            viewModel.getVideoDetails(for: viewModel.url)
        }
    }
    
    @ViewBuilder
    private var downloadView: some View {
        if let details = viewModel.details {
            DownloadView<DownloaderViewModel>(videoDetails: details)
        }
    }
}

struct VideoURLView_Previews: PreviewProvider{
    static var previews: some View {
        Group {
            URLView<DownloaderViewModel>()
                .environmentObject(DownloaderViewModel())
                .previewDevice("iPhone 13 Pro Max")
                .previewDisplayName("iPhone 13 Pro Max")
            URLView<DownloaderViewModel>()
                .environmentObject(DownloaderViewModel())
                .previewDevice("iPhone SE (3rd generation)")
                .previewDisplayName("iPhone SE")
        }
    }
}
