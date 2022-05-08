//
//  ViewDetailsViewModel.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import Foundation
import SwiftUI

protocol VideoDetailsProtocol: ObservableObject {
    func getVideoDetails(for url: URL)
}

final class VideoDetailsViewModel: VideoDetailsProtocol {
    
    let apiService: DataService
    
    init(apiService: DataService = ApiService()) {
        self.apiService = apiService
    }
    
    func getVideoDetails(for url: URL) {
        apiService.getVideoDetails(from: url)
    }
}
