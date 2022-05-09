//
//  View+Extensions.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/9/22.
//

import SwiftUI

extension View {
    func showLoader(
        when isLoading: Bool,
        title: String = "Loading",
        showOverlay: Bool = false
    ) -> some View {
        ZStack {
            self.allowsHitTesting(!isLoading)
            if isLoading {
                Loader(title: title, showOverlay: showOverlay)
            }
        }
    }
}
