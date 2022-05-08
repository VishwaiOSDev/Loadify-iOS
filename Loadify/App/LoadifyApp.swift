//
//  LoadifyApp.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import SwiftUI

@main
struct LoadifyApp: App {
    
    @StateObject var viewModel = VideoDetailsViewModel()
    
    var body: some Scene {
        WindowGroup {
            VideoURLView(viewModel: viewModel)
                .preferredColorScheme(.dark)
        }
    }
}
