//
//  LoadifyApp.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import SwiftUI
import LoadifyKit

@main
struct LoadifyApp: App {
    
    @StateObject var downloaderViewModel = DownloaderViewModel()
    @StateObject var loaderAction: LoaderViewAction = .init()
    @StateObject var alertAction: AlertViewAction = .init()
    
    init() {
        setupDependencyInjection()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                URLView(viewModel: downloaderViewModel)
                    .environmentObject(loaderAction)
                    .environmentObject(alertAction)
                    .addLoaderView(for: loaderAction)
                    .addAlertView(for: alertAction)
                    .preferredColorScheme(.dark)
                    .navigationBarHidden(true)
            }
        }
    }
}
