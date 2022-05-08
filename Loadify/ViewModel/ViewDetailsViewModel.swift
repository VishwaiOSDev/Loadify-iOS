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
    
    func getVideoDetails(for url: URL) {
        print("Get details from \(url)")
    }
}
