//
//  LoadifyApp.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import SwiftUI
import LoadifyKit
import SwiftDI

@main
struct LoadifyApp: App {
    
    @StateObject var downloaderViewModel = DownloaderViewModel()
    @StateObject var alertAction: AlertViewAction = .init()
    
    init() {
        SwiftDI.shared.setupDependencyInjection()
    }
    
    var body: some Scene {
        WindowGroup {
            URLView(viewModel: downloaderViewModel)
                .environmentObject(alertAction)
                .addAlertView(for: alertAction)
                .preferredColorScheme(.dark)
        }
    }
}
