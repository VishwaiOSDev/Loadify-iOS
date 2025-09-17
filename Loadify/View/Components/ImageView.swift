//
//  ImageView.swift
//
//
//  Created by Vishweshwaran on 23/10/22.
//

import SwiftUI
import LoadifyEngine

struct ImageView<Placeholder: View, ConfiguredImage: View, Loading: View>: View {
    
    @StateObject var imageLoader: ImageLoaderService
    @State private var uiImage: UIImage?
    
    private let platformType: Platform?
    private let placeholder: () -> Placeholder
    private let image: (Image) -> ConfiguredImage
    private let onLoading: () -> Loading
    
    init(
        urlString: String,
        platformType: Platform? = nil,
        @ViewBuilder placeholder: @escaping () -> Placeholder,
        @ViewBuilder image: @escaping (Image) -> ConfiguredImage,
        @ViewBuilder onLoading: @escaping () -> Loading
    ) {
        self.placeholder = placeholder
        self.platformType = platformType
        self.image = image
        self.onLoading = onLoading
        self._imageLoader = StateObject(wrappedValue: ImageLoaderService(urlString: urlString))
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            switch imageLoader.imageStatus {
            case .success(let uiImage):
                image(Image(uiImage: uiImage))
                    .contextMenu {
                        Button {
                            UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
                        } label: {
                            Label("Save to Photos", systemImage: "square.and.arrow.down")
                        }
                    }
            case .failure:
                placeholder()
            case .loading:
                onLoading()
            }
        }
        .overlay(alignment: .topTrailing) {
            if let platformType {
                PlatformBadgeView(platformType: platformType)
            }
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    
    static var previews: some View {
        ImageView(urlString: Constants.iMacURL, platformType: .instagram) {
            Image(systemName: "applelogo")
                .imageScale(.large)
        } image: { imageView in
            imageView
                .resizable()
                .scaledToFit()
                .padding()
        } onLoading: {
            ProgressView()
        }
    }
}
