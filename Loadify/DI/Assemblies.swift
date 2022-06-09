//
//  Assemblies.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/15/22.
//

import Foundation
import SwiftDI
import Swinject
import SwinjectAutoregistration

class SerivceAssembly: Assembly {
    func assemble(container: Container) {
        container.autoregister(DataService.self, initializer: ApiService.init).inObjectScope(.singleton)
        container.autoregister(FileServiceProtocol.self, initializer: FileService.init).inObjectScope(.singleton)
        container.autoregister(PhotosServiceProtocol.self, initializer: PhotosService.init).inObjectScope(.singleton)
    }
}
