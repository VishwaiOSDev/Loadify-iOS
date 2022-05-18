//
//  LoadifyApp.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import SwiftUI
import SwiftDI
import Swinject
import LoadifyKit

@main
struct LoadifyApp: App {
    
    @StateObject var downloaderViewModel = DownloaderViewModel()
    @StateObject var loader: LoaderState = .init()
    
    init() {
        setupDependencyInjection()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                URLView(viewModel: downloaderViewModel)
                    .environmentObject(loader)
                    .showAlert(loaderState: loader)
                    .preferredColorScheme(.dark)
                    .navigationBarHidden(true)
            }
        }
    }
}

extension LoadifyApp {
    func setupDependencyInjection() {
        SwiftDI.shared.setup(assemblies: [
            SerivceAssembly(),
            ViewModelAssembly()
        ], inContainer: Container())
    }
}
