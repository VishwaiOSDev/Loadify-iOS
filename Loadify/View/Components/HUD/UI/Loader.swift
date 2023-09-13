//
//  Loader.swift
//  
//
//  Created by Vishweshwaran on 11/06/22.
//

import SwiftUI
import FontKit

public struct Loader: View {
    
    public let title: String
    public let showOverlay: Bool
    
    public init(
        title: String,
        showOverlay: Bool = false
    ) {
        self.title = title
        self.showOverlay = showOverlay
    }
    
    public var body: some View {
        ZStack {
            overlayView(showOverlay)
            VStack {
                ProgressView()
                loaderTitle
                    .padding(.top, 6)
                
            }
            .loaderBackground()
        }
    }
    
    private var loaderTitle: some View {
        Text(title)
            .font(.inter(.regular(size: 12)))
            .foregroundColor(.gray)
    }
    
    private func overlayView(_ canShowOverlay: Bool) -> some View {
        canShowOverlay ? Color.black.opacity(0.2): Color.clear
    }
}

struct Loader_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Loader(title: "LOADING", showOverlay: false)
            Loader(title: "LOADING", showOverlay: false)
                .previewDevice("iPhone SE (3rd generation)")
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
}
