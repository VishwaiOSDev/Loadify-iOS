//
//  Protocols.swift
//  Loadify
//
//  Created by Vishweshwaran on 06/06/22.
//

import SwiftUI

protocol Urlable: ObservableObject {
    var url: String { get set }
}

protocol Loadable: Urlable {
    var detailsError: Error? { get set }
}

protocol Describable: Loadable {
    var details: VideoDetails? { get set }
}

protocol Navigatable: Describable {
    var shouldNavigateToDownload: Bool { get set }
}
