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
    
    // TODO: - Try swinject here aswell
    @ObservedObject var urlViewModel: URLViewModel
    
    func view(for route: AppRoute) -> some View {
        switch route {
        case .urlView:
            URLView(router: self, viewModel: urlViewModel)
        case .downloadView:
            getDownloadView()
        }
    }
    
    @ViewBuilder
    fileprivate func getDownloadView() -> some View {
        if let details = urlViewModel.details {
            DownloadView(router: self, videoDetails: details)
        }
    }
}
