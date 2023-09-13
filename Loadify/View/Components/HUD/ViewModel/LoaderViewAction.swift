//
//  File.swift
//  
//
//  Created by Vishweshwaran on 5/10/22.
//

import SwiftUI

public final class LoaderViewAction: ObservableObject {
    
    @Published var isLoading: Bool = false
    private(set) var title: String = ""
    private(set) var subTitle: String?
    
    public init() {
        print("Loader State Init")
    }
    
    deinit {
        print("LoaderViewAction DeInit")
    }
    
    public func showLoader(title: String, subTitle: String? = nil) {
        self.title = title
        self.subTitle = subTitle
        DispatchQueue.main.async {
            self.isLoading = true
        }
    }
    
    public func hideLoader() {
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
}
