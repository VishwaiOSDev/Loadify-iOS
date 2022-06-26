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
    var detailsError: Error? { get set }
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
