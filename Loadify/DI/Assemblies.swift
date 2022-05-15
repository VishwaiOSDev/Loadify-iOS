//
//  Assemblies.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/15/22.
//

import Foundation
import Swinject
import SwinjectAutoregistration

class SerivceAssembly: Assembly {
    func assemble(container: Container) {
        container.autoregister(DataService.self, initializer: ApiService.init).inObjectScope(.singleton)
    }
}


class ViewModelAssembly: Assembly {
    // MARK: - Change the DownloaderViewModel to Downloadable
    func assemble(container: Container) {
        container.autoregister(DownloaderViewModel.self, initializer: DownloaderViewModel.init).inObjectScope(.singleton)
    }
}
