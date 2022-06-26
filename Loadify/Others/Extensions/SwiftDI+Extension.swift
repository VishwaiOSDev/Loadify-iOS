//
//  App+Extension.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/18/22.
//

import SwiftDI
import Swinject

extension SwiftDI {
    func setupDependencyInjection() {
        SwiftDI.shared.setup(assemblies: [
            SerivceAssembly(),
        ], inContainer: Container())
    }
}
