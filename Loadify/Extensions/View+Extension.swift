//
//  View+Extensions.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/9/22.
//

import SwiftUI

extension View {
    
    func embedInNavigation() -> some View {
        NavigationView { self }
    }
}
