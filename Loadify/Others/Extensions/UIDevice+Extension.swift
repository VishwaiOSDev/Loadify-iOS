//
//  UIDevice+Extension.swift
//  Loadify
//
//  Created by Vishweshwaran on 2023-09-12.
//

import UIKit

extension UIDevice {
    
    /// Returns `true` if the device has a notch
    var hasNotch: Bool {
        let firstScene = UIApplication.shared.connectedScenes.first as! UIWindowScene

        guard let window = firstScene.windows.first else {
            return false
        }
        
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 44
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }
}
