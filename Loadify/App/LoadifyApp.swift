//
//  LoadifyApp.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import SwiftUI
import SwiftDI

@main
struct LoadifyApp: App {
    
    @StateObject var urlViewModel = DownloaderViewModel()
    
    init() {
        SwiftDI.shared.setupDependencyInjection()
    }
    
    var body: some Scene {
        WindowGroup {
            URLView<DownloaderViewModel>()
                .embedInNavigation()
                .accentColor(Loadify.Colors.blue_accent)
                .environmentObject(urlViewModel)
                .preferredColorScheme(.dark)
        }
    }
}
