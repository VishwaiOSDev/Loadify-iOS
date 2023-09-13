//
//  ImageView.swift
//  
//
//  Created by Vishweshwaran on 23/10/22.
//

import SwiftUI

public struct ImageView<Placeholder: View, ConfiguredImage: View, Loading: View>: View {
    
    @StateObject var imageLoader: ImageLoaderService
    @State private var uiImage: UIImage?
    
    private let placeholder: () -> Placeholder
    private let image: (Image) -> ConfiguredImage
    private let onLoading: () -> Loading
    
    public init(
        urlString: String,
        @ViewBuilder placeholder: @escaping () -> Placeholder,
        @ViewBuilder image: @escaping (Image) -> ConfiguredImage,
        @ViewBuilder onLoading: @escaping () -> Loading
    ) {
        self.placeholder = placeholder
        self.image = image
        self.onLoading = onLoading
        self._imageLoader = StateObject(wrappedValue: ImageLoaderService(urlString: urlString))
    }
    
    public var body: some View {
        ZStack {
            switch imageLoader.imageStatus {
            case .success(let uiImage):
                image(Image(uiImage: uiImage))
            case .failure:
                placeholder()
            case .loading:
                onLoading()
            }
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(urlString: Constants.iMacURL) {
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
