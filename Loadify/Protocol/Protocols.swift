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
    var errorMessage: String? { get set }
}

protocol DownloadableError: ObservableObject {
    var downloadError: Error? { get set }
    var showSettingsAlert: Bool { get set }
}

protocol Describable: DetailableError {
    var details: Decodable? { get set }
}

protocol Navigatable: Describable {
    var shouldNavigateToDownload: Bool { get set }
}

// MARK: - Network Service

protocol URLSessionProtocol {
    func fetch(for request: URLRequest) async throws -> (Data, HTTPURLResponse)
    func download(for request: URLRequest)
}
