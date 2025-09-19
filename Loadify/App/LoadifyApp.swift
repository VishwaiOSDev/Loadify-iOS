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
    @State var reachablity = ReachablityManager()
    
    init() {
        FontKit.registerInter()
    }
    
    var body: some Scene {
        WindowGroup {
            URLView()
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
