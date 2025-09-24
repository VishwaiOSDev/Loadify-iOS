//
//  VideoURLView.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import SwiftUI
import LoadifyEngine

struct URLView: View {
    
    @State var viewModel = URLViewModel()
    @State private var videoURL: String = ""
    @State private var isConvertButtonDisabled: Bool = false
    
    var body: some View {
        NavigationStack(path: $viewModel.path) {
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
            .onAppear(perform: {
                setupPasteboardObserver()
            })
            .navigationBarHidden(true)
            .showLoader(LoadifyTexts.loading, isPresented: $viewModel.showLoader)
            .onChange(of: videoURL, {
                withAnimation {
                    isConvertButtonDisabled = videoURL.isEmpty
                }
            })
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                Task {
                    checkPasteboard()
                }
            }
            .showAlert(item: $viewModel.errorMessage, content: { errorMessage -> AlertUI in
                guard let errorTitle = LoadifyTexts.tryAgain.randomElement() else {
                    return AlertUI(title: errorMessage)
                }
                return AlertUI(title: errorTitle, subtitle: errorMessage)
            })
            .navigationDestination(for: LoadifyNavigationPath.self) { path in
                switch path {
                case .downloader(let response):
                    DownloaderView(response: response)
                }
            }
        }
    }
    
    @ViewBuilder
    private var headerView: some View {
        LoadifyAssets.loadifyIcon
            .frame(maxWidth: 150, maxHeight: 150)
        Text(LoadifyTexts.loadifySubTitle)
            .padding(.vertical, 8)
            .foregroundColor(LoadifyColors.greyText)
            .font(.inter(.regular(size: 14)))
            .multilineTextAlignment(.center)
    }
    
    private var textFieldView: some View {
        VStack(spacing: 12) {
            CustomTextField("Enter Instagram or TikTok URL", text: $videoURL)
            DownloadButton("Convert", isDisabled: isConvertButtonDisabled) {
                Task {
                    await didTapContinue()
                }
            }
        }
    }
    
    private func didTapContinue() async {
        hideKeyboard()
        let trimmedURL = videoURL.trimmingCharacters(in: .whitespacesAndNewlines)
        await viewModel.getVideoDetails(for: trimmedURL)
    }
    
    private func checkPasteboard() {
        if let pasteboardString = UIPasteboard.general.string {
            videoURL = pasteboardString
        }
    }
    
    private func setupPasteboardObserver() {
        Task {
            checkPasteboard()
        }
    }
}

#Preview {
    URLView(viewModel: URLViewModel())
}
