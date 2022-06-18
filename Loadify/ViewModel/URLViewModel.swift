//
//  URLViewModel.swift
//  Loadify
//
//  Created by Vishweshwaran on 18/06/22.
//

import Foundation
import SwiftDI

final class URLViewModel: Detailable {
    
    // Wrappers
    @Published var url: String = ""
    @Published var shouldNavigateToDownload: Bool = false
    @Published var detailsError: Error? = nil
    @Published var showLoader: Bool = false
    @Inject var apiService: DataService
    
    // Properties
    var details: VideoDetails? = nil
    
    func getVideoDetails(for url: String) async {
        do {
            DispatchQueue.main.async {
                self.showLoader = true
            }
            // TODO: - Restrict the the apiSerivce.downloadVideo() func.
            let response = try await apiService.getVideoDetails(for: url)
            DispatchQueue.main.async {
                self.details = response
                self.showLoader = false
                self.shouldNavigateToDownload = true
            }
        } catch {
            DispatchQueue.main.async {
                Task {
                    try await Task.sleep(seconds: 0.3)
                    self.showLoader = false
                    self.detailsError = error
                }
            }
        }
    }
}
