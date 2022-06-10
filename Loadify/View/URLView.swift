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
        }
        .navigationBarHidden(true)
        .customLoader("Fetching Details...", isPresented: $viewModel.showLoader)
        .customAlert(item: $viewModel.detailsError) { error in
            AlertView(title: error.localizedDescription)
                .dismiss {
                    viewModel.detailsError = nil
                }
        }
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
                Button {
                    Task {
                        await didTapContinue()
                    }
                } label: {
                    Text("Continue")
                        .bold()
                }
                .buttonStyle(CustomButtonStyle(isDisabled: viewModel.url.checkIsEmpty()))
            }
            .disabled(viewModel.url.checkIsEmpty())
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
    private var downloadView: some View {
        if let details = viewModel.details {
            DownloadView<DownloaderViewModel>(details: details)
        }
    }
    
    private func didTapContinue() async {
        await viewModel.getVideoDetails(for: viewModel.url)
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
