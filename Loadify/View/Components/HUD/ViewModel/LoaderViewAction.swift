//
//  File.swift
//  
//
//  Created by Vishweshwaran on 5/10/22.
//

import SwiftUI

final class LoaderViewAction: ObservableObject {
    
    @Published var isLoading: Bool = false
    private(set) var title: String = ""
    private(set) var subTitle: String?
    
    func showLoader(title: String, subTitle: String? = nil) {
        self.title = title
        self.subTitle = subTitle
        DispatchQueue.main.async {
            self.isLoading = true
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
}
