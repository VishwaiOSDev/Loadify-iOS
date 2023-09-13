//
//  AlertViewAction.swift
//  
//
//  Created by Vishweshwaran on 5/19/22.
//

import SwiftUI

public final class AlertViewAction: ObservableObject {
    
    @Published var isShowing: Bool = false
    private(set) var title: String
    private(set) var subTitle: String?
    private(set) var showOverlay: Bool
    private(set) var options: AlertOptions
    
    public init(
        title: String = "",
        subTitle: String? = nil,
        showOverlay: Bool = false,
        options: AlertOptions = .init(alertType: .error, style: .vertical)
    ) {
        self.title = title
        self.subTitle = subTitle
        self.showOverlay = showOverlay
        self.options = options
    }
    
    deinit {
        print("LoaderViewAction DeInit")
    }
    
    public func showAlert(
        title: String,
        subTitle: String? = nil,
        duration: Int = 3,
        showOverlay: Bool = false,
        options: AlertOptions = .init(alertType: .error)
    ) {
        self.title = title
        self.subTitle = subTitle
        self.options = options
        DispatchQueue.main.async {
            self.isShowing = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(duration)) {
            self.isShowing = false
        }
    }
}
