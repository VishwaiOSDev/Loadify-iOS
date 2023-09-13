//
//  LoaderView.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/9/22.
//

import SwiftUI

@available(*, deprecated, message: "use Loader instead")
public struct LoaderView: View {
    
    public let title: String
    public let subTitle: String?
    public let showOverlay: Bool
    public let options: LoaderOptions
    
    public init(
        title: String,
        subTitle: String? = nil,
        showOverlay: Bool = false,
        options: LoaderOptions = .init(style: .horizontal)
    ) {
        self.title = title
        self.subTitle = subTitle
        self.showOverlay = showOverlay
        self.options = options
    }
    
    public var body: some View {
        ZStack {
            overlayView(showOverlay)
            switch options.style {
            case .horizontal:
                horizontalLoader
                    .frame(maxWidth: 230, maxHeight: 80)
                    .loaderBackground()
            case .vertical:
                verticalLoader
                    .frame(maxWidth: 230, maxHeight: 80)
                    .loaderBackground()
            }
        }
    }
    
    private var horizontalLoader: some View {
        HStack(alignment: .center, spacing: 16) {
            ProgressView()
            contentView
        }
    }
    
    private var verticalLoader: some View {
        VStack(alignment: .center, spacing: 12) {
            ProgressView()
            contentView
        }
    }
    
    private var contentView: some View {
        VStack(spacing: 4) {
            Text("\(title)")
                .font(.headline)
                .foregroundColor(.white)
            subTitle.map({
                Text($0)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            })
        }
    }
    
    private func overlayView(_ canShowOverlay: Bool) -> some View {
        canShowOverlay ? Color.black.opacity(0.2): Color.clear
    }
}

@available(*, deprecated, message: "use Loader_Previews instead")
struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoaderView(title: "Fetching details...", subTitle: nil, showOverlay: false, options: .init(style: .vertical))
            LoaderView(title: "Fetching details...", subTitle: nil, showOverlay: false, options: .init(style: .horizontal))
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
}
