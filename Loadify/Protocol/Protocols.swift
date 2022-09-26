//
//  Protocols.swift
//  Loadify
//
//  Created by Vishweshwaran on 06/06/22.
//

import SwiftUI

protocol Loadable: ObservableObject {
    var showLoader: Bool { get set }
}

protocol DetailableError: Loadable {
    var error: Error? { get set }
}

protocol DownloadableError: ObservableObject {
    var downloadError: Error? { get set }
    var showSettingsAlert: Bool { get set }
}

protocol Describable: DetailableError {
    var details: VideoDetails? { get set }
}

protocol Navigatable: Describable {
    var shouldNavigateToDownload: Bool { get set }
}

// MARK: - API Service

protocol FetchService {
    func fetchVideoDetailsFromApi(for url: String) async throws -> VideoDetails
}

protocol DownloadService {
    func downloadVideo(for url: String, quality: VideoQuality) async throws
}
