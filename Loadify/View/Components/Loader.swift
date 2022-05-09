//
//  Loader.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/9/22.
//

import SwiftUI

// TODO:- Add this loader into new package names LoaderKit
struct Loader: View {
    
    let title: String
    let showOverlay: Bool
    
    init(title: String, showOverlay: Bool) {
        self.title = title
        self.showOverlay = showOverlay
    }
    
    var body: some View {
        ZStack {
            overlayView
            VStack {
                ProgressView(title)
            }
            .padding()
            .background(Blur())
            .cornerRadius(10)
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        if showOverlay {
            Color.black.opacity(0.2)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct Loader_Previews: PreviewProvider {
    static var previews: some View {
        Loader(title: "Loading", showOverlay: false)
            .previewLayout(.sizeThatFits)
    }
}
