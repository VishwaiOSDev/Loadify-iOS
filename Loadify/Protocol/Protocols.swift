//
//  Protocols.swift
//  Loadify
//
//  Created by Vishweshwaran on 06/06/22.
//

import SwiftUI

@MainActor
protocol Loadable {
    var showLoader: Bool { get set }
}

@MainActor
protocol DetailableError: Loadable {
    var errorMessage: String? { get set }
}

@MainActor
protocol DownloadableError {
    var downloadError: Error? { get set }
    var isDownloading: Bool { get set }
    var showSettingsAlert: Bool { get set }
}

@MainActor
protocol Describable: DetailableError {
    var details: Decodable? { get set }
}

@MainActor
protocol Navigatable: Describable {
    var shouldNavigateToDownload: Bool { get set }
}

// MARK: - Network Service

protocol URLSessionProtocol {
    func fetch(for request: URLRequest) async throws -> (Data, HTTPURLResponse)
    func download(for request: URLRequest)
    func finishAndInvalidate()
}
