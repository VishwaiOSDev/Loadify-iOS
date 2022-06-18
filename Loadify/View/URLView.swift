//
//  VideoURLView.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import SwiftUI
import SwiftDI
import LoadifyKit

struct URLView: View {
    
    @StateObject var urlViewModel: URLViewModel = URLViewModel()
    @State var videoUrl: String = ""
    @State var showWebView: Bool = false
    
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
        .showLoader(Texts.loading, isPresented: $urlViewModel.showLoader)
        .showAlert(item: $urlViewModel.detailsError) { error in
            AlertUI(title: error.localizedDescription, subtitle: Texts.try_again.randomElement())
        }
    }
    
    @ViewBuilder
    private var headerView: some View {
        Image(Loadify.Images.loadify_icon)
            .frame(maxWidth: 150, maxHeight: 150)
        Text("The secret of getting ahead is getting started.")
            .foregroundColor(Loadify.Colors.grey_text)
            .font(.subheadline)
            .multilineTextAlignment(.center)
    }
    
    private var textFieldView: some View {
        VStack(spacing: 12) {
            CustomTextField("Enter YouTube URL", text: $videoUrl)
            NavigationLink(
                destination: downloadView,
                isActive: $urlViewModel.shouldNavigateToDownload
            ) {
                Button {
                    Task {
                        await didTapContinue()
                    }
                } label: {
                    Text("Continue")
                        .bold()
                }
                .buttonStyle(CustomButtonStyle(isDisabled: videoUrl.checkIsEmpty()))
            }
            .disabled(videoUrl.checkIsEmpty())
        }
        .showLoader("Loading", isPresented: $showWebView)
    }
    
    private var termsOfService: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 4) {
                    Text("By continuing, you agree to our")
                    NavigationLink(destination: webView(url: Api.Web.privacyPolicy)) {
                        Text("Privacy Policy")
                            .bold()
                            .foregroundColor(Loadify.Colors.blue_accent)
                    }
                    Text("and")
                }
                HStack(spacing: 4) {
                    Text("our")
                    NavigationLink(destination: webView(url: Api.Web.termsOfService)) {
                        Text("Terms of Service")
                            .bold()
                            .foregroundColor(Loadify.Colors.blue_accent)
                    }
                }
            }
        }
        .foregroundColor(Loadify.Colors.grey_text)
        .font(.footnote)
    }
    
    @ViewBuilder
    private var downloadView: some View {
        if let details = urlViewModel.details {
            DownloadView(details: details)
        }
    }
    
    private func didTapContinue() async {
        hideKeyboard()
        await urlViewModel.getVideoDetails(for: videoUrl)
    }
    
    func webView(url: Api.Web) -> some View {
        WebView(url: url.rawValue, showLoading: $showWebView)
            .showLoader("Loading", isPresented: $showWebView)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Loadify's Agreement")
            .accentColor(Colors.blue_accent)
    }
}

struct VideoURLView_Previews: PreviewProvider{
    static var previews: some View {
        Group {
            URLView()
                .previewDevice("iPhone 13 Pro Max")
                .previewDisplayName("iPhone 13 Pro Max")
            URLView()
                .previewDevice("iPhone SE (3rd generation)")
                .previewDisplayName("iPhone SE")
        }
        .preferredColorScheme(.dark)
    }
}
