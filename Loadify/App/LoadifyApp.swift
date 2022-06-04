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
    
    @StateObject var downloaderViewModel = URLViewModel()
    @StateObject var alertAction: AlertViewAction = .init()
    
    init() {
        SwiftDI.shared.setupDependencyInjection()
    }
    
    var body: some Scene {
        WindowGroup {
            AppRouter(downloaderViewModel: downloaderViewModel).view(for: .urlView)
                .embedInNavigation()
                .environmentObject(alertAction)
                .addAlertView(for: alertAction)
                .preferredColorScheme(.dark)
        }
    }
}
