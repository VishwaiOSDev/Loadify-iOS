//
//  LoadifyApp.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import SwiftUI
import FontKit
import FontInter

@main
struct LoadifyApp: App {
    
    @StateObject var reachablilityManager = ReachablityManager()
    
    init() {
        FontKit.registerInter()
    }
    
    var body: some Scene {
        WindowGroup {
            URLView(viewModel: URLViewModel())
                .embedInNavigation()
                .navigationViewStyle(StackNavigationViewStyle())
                .accentColor(Loadify.Colors.blue_accent)
                .preferredColorScheme(.dark)
                .alert(isPresented: $reachablilityManager.isConnected.invert) {
                    Alert(
                        title: Text(Texts.no_internet),
                        message: Text(Texts.no_internet_message),
                        dismissButton: .cancel(Text("OK"))
                    )
                }
        }
    }
}
