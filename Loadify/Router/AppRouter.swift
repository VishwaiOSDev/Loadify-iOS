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
    @ObservedObject var downloaderViewModel: DownloaderViewModel
    
    func view(for route: AppRoute) -> some View {
        switch route {
        case .urlView:
            URLView(router: self, viewModel: downloaderViewModel)
        case .downloadView:
            getDownloadView()
        }
    }
    
    @ViewBuilder
    fileprivate func getDownloadView() -> some View {
        if let details = downloaderViewModel.details {
            DownloadView(router: self, videoDetails: details)
        }
    }
}
