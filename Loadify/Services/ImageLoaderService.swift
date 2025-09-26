//
//  ImageLoaderService.swift
//
//
//  Created by Vishweshwaran on 23/10/22.
//

import Foundation
import UIKit

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
    
    private func setImageStatus(to imageStatus: ImageStatus) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.imageStatus = imageStatus
        }
    }
}
