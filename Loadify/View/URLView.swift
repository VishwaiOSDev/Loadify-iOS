//
//  VideoURLView.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import SwiftUI

struct URLView<ViewModel>: View where ViewModel: Downloadable {
    
    @ObservedObject var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Loadify.Colors.app_background
                .edgesIgnoringSafeArea(.all)
            VStack {
                Image(Loadify.Images.loadify_icon)
                    .frame(maxWidth: 150, maxHeight: 150)
                Text("We are the best Audio and Video downloader \n app ever")
                    .foregroundColor(Loadify.Colors.grey_text)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                Spacer()
                VStack(spacing: 12) {
                    CustomTextField("Enter YouTube URL", text: $viewModel.url)
                    Button(action: didTapContinue) {
                        Text("Continue")
                            .bold()
                    }.buttonStyle(CustomButtonStyle())
                }.padding(.horizontal, 16)
                Spacer()
                termsOfService
            }
            .padding()
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
    
    func didTapContinue() {
        let urlString = AppConstants.Api.apiUrl + "/yt/details?url=" + viewModel.url
        viewModel.getVideoDetails(for: URL(string: urlString)!)
    }
}

struct VideoURLView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            URLView(viewModel: DownloaderViewModel())
                .previewDevice("iPhone 13 Pro Max")
                .previewDisplayName("iPhone 13 Pro Max")
            URLView(viewModel: DownloaderViewModel())
                .previewDevice("iPhone SE (3rd generation)")
                .previewDisplayName("iPhone SE")
            URLView(viewModel: DownloaderViewModel())
                .previewDevice("iPad Pro (11-inch) (3rd generation)")
                .previewDisplayName("iPad Pro")
        }
    }
}

struct Loadify {
    struct Colors {
        static let app_background = Color("app_background")
        static let grey_text = Color("grey_text")
        static let textfield_background = Color("textfield_background")
        static let blue_accent = Color("blue_accent")
    }
    
    struct Images {
        static let loadify_icon = "loadify_icon"
    }
}
