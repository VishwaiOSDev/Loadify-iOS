//
//  View+Extensions.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/9/22.
//

import SwiftUI
import LoadifyKit

extension View {
    
    func embedInNavigation() -> some View {
        NavigationView { self }
    }
    
    func cardView(color: Color, cornerRadius: CGFloat = 10) -> some View {
        modifier(CardView(color: color, cornerRadius: cornerRadius))
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
