//
//  LoaderBackground.swift
//  
//
//  Created by Vishweshwaran on 5/18/22.
//

import SwiftUI

struct LoaderBackground: ViewModifier {
    
    let colors: [Color]?
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Blur().background(blurColor))
            .cornerRadius(12)
    }
    
    @ViewBuilder
    private var blurColor: some View {
        if let colors = colors {
            LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
        } else {
            Color.clear
        }
    }
}

