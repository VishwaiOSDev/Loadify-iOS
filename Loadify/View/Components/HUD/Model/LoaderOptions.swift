//
//  LoaderOptions.swift
//  
//
//  Created by Vishweshwaran on 5/18/22.
//

import SwiftUI

public enum LoaderStyle {
    case vertical, horizontal
}

public struct LoaderOptions {
    public var style: LoaderStyle
    
    public init(style: LoaderStyle = .horizontal) {
        self.style = style
    }
}
