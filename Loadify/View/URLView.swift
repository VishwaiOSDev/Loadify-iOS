//
//  VideoURLView.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import SwiftUI
import LoadifyEngine

enum LoadifyNavigationPath: Hashable {
    case downloader(details: LoadifyResponse)
}

struct URLView: View {
    
    @State var viewModel = URLViewModel()
    @State private var videoURL: String = ""
    @State private var isConvertButtonDisabled: Bool = false
    @State private var shouldNavigateToDownload = false
    
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
            .onDisappear(perform: viewModel.onDisappear)
            .showLoader(LoadifyTexts.loading, isPresented: $viewModel.showLoader)
            .onChange(of: videoURL, {
                withAnimation {
                    isConvertButtonDisabled = videoURL.isEmpty
                }
            })
            .showAlert(item: $viewModel.errorMessage, content: { errorMessage -> AlertUI in
                guard let errorTitle = LoadifyTexts.tryAgain.randomElement() else {
                    return AlertUI(title: errorMessage)
                }
                return AlertUI(title: errorTitle, subtitle: errorMessage)
            })
            .navigationDestination(for: LoadifyNavigationPath.self) { path in
                switch path {
                case .downloader(let details):
                    InstagramDownloaderView(details: details)
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
            CustomTextField("Enter YouTube or Instagram URL", text: $videoURL)
            DownloadButton("Convert", isDisabled: isConvertButtonDisabled) {
                Task {
                    await didTapContinue()
                }
            }
            .disabled(isConvertButtonDisabled)
            
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
        let trimmedURL = videoURL.trimmingCharacters(in: .whitespacesAndNewlines)
        await viewModel.getVideoDetails(for: trimmedURL)
        Logger.debug("Go to DownloaderView...")
        //        shouldNavigateToDownload = true
    }
    
    private func checkPasteboard() async {
        if let pasteboardString = UIPasteboard.general.string {
            videoURL = pasteboardString
        }
    }
    
    private func setupPasteboardObserver() {
        Task {
            await checkPasteboard()
        }
        NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main
        ) { _ in
            Task {
                await checkPasteboard()
            }
        }
    }
}

#Preview {
    URLView(viewModel: URLViewModel())
}
