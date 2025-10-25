//
//  ImageView.swift
//
//
//  Created by Vishweshwaran on 23/10/22.
//

import SwiftUI
import LoadifyEngine
import AVFoundation
import UIKit

struct ImageView<Placeholder: View, ConfiguredImage: View, Loading: View>: View {
    
    @StateObject var imageLoader: ImageLoaderService
    @State private var uiImage: UIImage?
    
    private let urlString: String?
    private let shouldGenerateThumbnail: Bool
    private let platformType: Platform?
    private let fileSize: Double?
    private let placeholder: () -> Placeholder
    private let image: (Image) -> ConfiguredImage
    private let onLoading: () -> Loading
    
    /// Generates a thumbnail (UIImage) from a video URL asynchronously.
    func generateThumbnail(for url: URL, at time: Double = 0.0) async -> UIImage? {
        let asset = AVURLAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        
        // Ensures the thumbnail has the correct orientation
        generator.appliesPreferredTrackTransform = true
        
        // CMTime specifies the time in the video to capture a frame.
        // We use a preferred timescale of 600 for high precision.
        let timestamp = CMTime(seconds: time, preferredTimescale: 600)
        
        do {
            // Use the async 'image(at:)' method to generate the CGImage
            let imageRef = try await generator.image(at: timestamp).image
            return UIImage(cgImage: imageRef)
        } catch {
            Logger.error("Error generating thumbnail for \(url): \(error)")
            return nil
        }
    }
    
    init(
        urlString: String? = nil,
        platformType: Platform? = nil,
        fileSize: Double? = nil,
        shouldGenerateThumbnail: Bool = false,
        @ViewBuilder placeholder: @escaping () -> Placeholder,
        @ViewBuilder image: @escaping (Image) -> ConfiguredImage,
        @ViewBuilder onLoading: @escaping () -> Loading
    ) {
        self.urlString = urlString
        self.platformType = platformType
        self.fileSize = fileSize
        self.shouldGenerateThumbnail = shouldGenerateThumbnail
        self.placeholder = placeholder
        self.image = image
        self.onLoading = onLoading
        self._imageLoader = StateObject(wrappedValue: ImageLoaderService())
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
                PlatformBadgeView(platformType: platformType, fileSize: fileSize)
            }
        }
        .task {
            guard let urlString else { return }
            
            if shouldGenerateThumbnail, let url = URL(string: urlString) {
                if let thumbnail = await generateThumbnail(for: url) {
                    await MainActor.run {
                        imageLoader.setImageStatus(to: .success(uiImage: thumbnail))
                    }
                }
            } else {
                imageLoader.loadData(from: urlString)
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
