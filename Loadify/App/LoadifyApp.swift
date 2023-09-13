//
//  LoadifyApp.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import UIKit
import SwiftUI
import FontKit
import Haptific
import FontInter

@main
struct LoadifyApp: App {
    
    /// `ReachablityManager` is for checking network connection
    @StateObject var reachablity = ReachablityManager()
    
    init() {
        FontKit.registerInter()
        Logger.configure()
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

// MARK: - Internal Helpers

func notifyWithHaptics(for type: UINotificationFeedbackGenerator.FeedbackType) {
    Haptific.simulate(.notification(style: type))
}
