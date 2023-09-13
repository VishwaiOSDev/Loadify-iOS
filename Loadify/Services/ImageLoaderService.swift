//
//  ImageLoaderService.swift
//  
//
//  Created by Vishweshwaran on 23/10/22.
//

import Foundation
import UIKit

final class ImageLoaderService: ObservableObject {
    
    public enum ImageStatus {
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
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                guard let uiImage = UIImage(data: data) else {
                    return self.setImageStatus(to: .failure)
                }
                self.setImageStatus(to: .success(uiImage: uiImage))
            }
        }
        setImageStatus(to: .loading)
        task.resume()
    }
    
    private func setImageStatus(to imageStatus: ImageStatus) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.imageStatus = imageStatus
        }
    }
}
