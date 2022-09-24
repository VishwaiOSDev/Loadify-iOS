//
//  VideoURLView.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import SwiftUI
import LoadifyKit

struct URLView<ViewModel>: View where ViewModel: Detailable {
    
    @ObservedObject var viewModel: ViewModel
    @State var videoURL: String = ""
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
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
            }
            .padding()
        }
        .navigationBarHidden(true)
        .showLoader(Texts.loading, isPresented: $viewModel.showLoader)
        .showAlert(item: $viewModel.error) { error in
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
            CustomTextField("Enter YouTube URL", text: $videoURL)
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
    
    private func didTapContinue() async {
        hideKeyboard()
        await viewModel.getVideoDetails(for: videoURL)
    }
}

struct VideoURLView_Previews: PreviewProvider{
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
