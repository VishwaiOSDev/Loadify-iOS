//
//  LoadifyApp.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import SwiftUI
import SwiftDI
import Swinject

@main
struct LoadifyApp: App {
    
    init() {
        setupDependencyInjection()
    }
    
    var body: some Scene {
        WindowGroup {
            URLView()
                .preferredColorScheme(.dark)
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
