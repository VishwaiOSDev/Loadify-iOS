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

// MARK: - Network Service

protocol URLSessionProtocol {
    func fetchData(for request: URLRequest) async throws -> (Data, HTTPURLResponse)
    func downloadData(for request: URLRequest) async throws -> (URL, HTTPURLResponse)
}
