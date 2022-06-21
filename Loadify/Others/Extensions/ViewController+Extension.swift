//
//  ViewController+Extension.swift
//  Loadify
//
//  Created by Vishweshwaran on 21/06/22.
//

import UIKit

extension UIViewController {
    var rootParent: UIViewController {
        if let parent = self.parent {
            return parent.rootParent
        }
        else {
            return self
        }
    }
}
