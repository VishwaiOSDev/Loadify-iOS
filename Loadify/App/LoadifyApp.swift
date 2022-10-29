//
//  LoadifyApp.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import SwiftUI
import FontKit
import FontInter
import LoadifyKit

@main
struct LoadifyApp: App {
    
    /// `ReachablityManager` is for checking network connection
    @StateObject var reachablity = ReachablityManager()
    
    init() {
        FontKit.registerInter()
    }
    
    var body: some Scene {
        WindowGroup {
            URLView()
                .embedInNavigation()
                .navigationViewStyle(StackNavigationViewStyle())
                .accentColor(LoadifyColors.blueAccent)
                .preferredColorScheme(.dark)
                .showNetworkAlert(when: reachablity.isConnected, with: reachablity.connectionDescription)
        }
    }
}
