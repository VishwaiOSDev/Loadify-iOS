//
//  ViewDetailsViewModel.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import SwiftUI
import SwiftDI

protocol Navigatable: ObservableObject {
    var shouldNavigateToDownload: Bool { get set }
}

protocol Loadable: ObservableObject {
    var showProgessView: Bool { get set }
}

// TODO: - Change the name of the Protocol
protocol Urlable: ObservableObject {
    var url: String { get set }
}

protocol Describable: Urlable {
    var details: VideoDetails? { get set }
}

protocol Detailable: Describable {
    func getVideoDetails(for url: String)
}

final class URLViewModel: Detailable, Loadable, Navigatable {
    
    @Published var url: String = "https://www.youtube.com/watch?v=CYYtLXfquy0"
    @Published var details: VideoDetails?
    @Published var showProgessView: Bool = false
    @Published var shouldNavigateToDownload: Bool = false
    @Inject var apiService: DataService
    
    func getVideoDetails(for url: String) {
        DispatchQueue.main.async {
            self.showProgessView = true
        }
        guard let apiUrl = URL(string: "https://api.tikapp.ml/api/yt/details?url=\(url)") else { return }
        apiService.getVideoDetails(url: apiUrl) { details in
            DispatchQueue.main.async {
                self.details = details
                self.showProgessView = false
                self.shouldNavigateToDownload = true
            }
        }
    }
}
