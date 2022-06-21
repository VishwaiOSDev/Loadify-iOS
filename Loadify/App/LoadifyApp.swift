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
    @StateObject var reachablilityManager = ReachablityManager()
    @AppStorage("OnboardingScreen") var isOnboardingScreenShown: Bool = false
    
    init() {
        SwiftDI.shared.setupDependencyInjection()
    }
    
    var body: some Scene {
        WindowGroup {
            URLView<DownloaderViewModel>()
                .embedInNavigation()
                .navigationViewStyle(StackNavigationViewStyle())
                .accentColor(Loadify.Colors.blue_accent)
                .environmentObject(urlViewModel)
                .preferredColorScheme(.dark)
                .alert(isPresented: $reachablilityManager.isConnected.invert) { noNetworkAlert }
                .sheet(isPresented: $isOnboardingScreenShown.invert) {
                    OnboardView()
                        .allowAutoDismiss(false)
                }
        }
    }
    
    private var noNetworkAlert: Alert {
        Alert(
            title: Text(Texts.no_internet),
            message: Text(Texts.no_internet_message),
            dismissButton: .cancel(Text("OK"))
        )
    }
}
