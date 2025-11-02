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
    @Environment(\.scenePhase) private var scenePhase
    
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
            // Navigation
            .navigationBarHidden(true)
            .navigationDestination(for: LoadifyNavigationPath.self) { path in
                switch path {
                case .downloader(let response):
                    DownloaderView(response: response)
                }
            }
            .onOpenURL {
                guard let url = viewModel.extractURLStringFromDeepLink(url: $0) else { return }
                self.videoURL = url
                Task {
                    await didTapContinue()
                }
            }
            // User feedback
            .showAlert(item: $viewModel.errorMessage, content: { errorMessage -> AlertUI in
                guard let errorTitle = LoadifyTexts.tryAgain.randomElement() else {
                    return AlertUI(title: errorMessage)
                }
                return AlertUI(title: errorTitle, subtitle: errorMessage)
            })
            .showLoader(LoadifyTexts.loading, isPresented: $viewModel.showLoader)
            // Lifecycle & state
            .onAppear {
                if viewModel.path.isEmpty {
                    Task {
                        checkPasteboard()
                    }
                }
            }
            .onChange(of: videoURL, {
                withAnimation {
                    isConvertButtonDisabled = videoURL.isEmpty
                }
            })
            .onChange(of: scenePhase, { _, newPhase in
                if newPhase == .active && viewModel.path.isEmpty {
                    checkPasteboard()
                }
            })
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
            CustomTextField("Enter the video url", text: $videoURL)
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
        // Only auto-fill from pasteboard if the field is empty
        guard videoURL.isEmpty else { return }
        if let pasteboardString = UIPasteboard.general.string {
            videoURL = pasteboardString
        }
    }
}

#Preview {
    URLView(viewModel: URLViewModel())
}
