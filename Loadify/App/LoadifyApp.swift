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
    
    @StateObject var urlViewModel = URLViewModel()
    @StateObject var alertAction: AlertViewAction = .init()
    
    init() {
        SwiftDI.shared.setupDependencyInjection()
    }
    
    var body: some Scene {
        WindowGroup {
            AppRouter().view(for: .urlView)
                .embedInNavigation()
                .environmentObject(alertAction)
                .environmentObject(urlViewModel)
                .addAlertView(for: alertAction)
                .preferredColorScheme(.dark)
        }
    }
}
