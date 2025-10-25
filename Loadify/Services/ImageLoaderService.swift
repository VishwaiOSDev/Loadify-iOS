//
//  ImageLoaderService.swift
//
//
//  Created by Vishweshwaran on 23/10/22.
//

import Foundation
import UIKit
import AVFoundation

// TODO: - Migrate to Observable API
final class ImageLoaderService: ObservableObject {
    
    enum ImageStatus {
        case success(uiImage: UIImage)
        case failure
        case loading
    }
    
    @Published var imageStatus: ImageStatus = .loading
    
    convenience init(urlString: String?) {
        self.init()
        loadData(from: urlString)
    }
    
    convenience init(uiImage: UIImage) {
        self.init()
        setImageStatus(to: .success(uiImage: uiImage))
    }
    
    func loadData(from urlString: String?) {
        setImageStatus(to: .loading)
        
        guard let urlString, let url = URL(string: urlString) else {
            return setImageStatus(to: .failure)
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self else { return }
            guard let data else { return self.setImageStatus(to: .failure) }
            
            if let uiImage = UIImage(data: data) {
                self.setImageStatus(to: .success(uiImage: uiImage))
            } else {
                self.setImageStatus(to: .failure)
            }
        }
        
        task.resume()
    }
    
    func setImageStatus(to imageStatus: ImageStatus) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.imageStatus = imageStatus
        }
    }
    
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
}
