//
//  UINavigationController+Extension.swift
//  Loadify
//
//  Created by Vishweshwaran on 09/06/22.
//

import UIKit

extension UINavigationController {
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBar.topItem?.backButtonDisplayMode = .minimal
    }
}
