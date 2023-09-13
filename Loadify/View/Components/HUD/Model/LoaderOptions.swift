//
//  LoaderOptions.swift
//  
//
//  Created by Vishweshwaran on 5/18/22.
//

import SwiftUI

enum LoaderStyle {
    case vertical, horizontal
}

struct LoaderOptions {
    
    var style: LoaderStyle
    
    init(style: LoaderStyle = .horizontal) {
        self.style = style
    }
}
