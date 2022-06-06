//
//  AppRouter.swift
//  Loadify
//
//  Created by Vishweshwaran on 04/06/22.
//

import SwiftUI

enum AppRoute {
    case urlView
    case downloadView
}

struct AppRouter: Routing {
    
    func view(for route: AppRoute) -> some View {
        switch route {
        case .urlView:
            URLView<URLViewModel, AppRouter>(router: self)
        case .downloadView:
            DownloadView<URLViewModel, AppRouter>(router: self)
        }
    }
}
