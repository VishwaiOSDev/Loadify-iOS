//
//  CardView.swift
//  Loadify
//
//  Created by Vishweshwaran on 10/06/22.
//

import SwiftUI

struct CardView: ViewModifier {
    
    let color: Color
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(color)
            .cornerRadius(cornerRadius)
    }
}
