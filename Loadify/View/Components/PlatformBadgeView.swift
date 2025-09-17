//
//  PlatformBadgeView.swift
//  Loadify
//
//  Created by Vishweshwaran on 2025-09-17.
//

import SwiftUI
import LoadifyEngine

struct PlatformBadgeView: View {
    
    let platformType: Platform
    
    init(platformType: Platform) {
        self.platformType = platformType
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            platformLogo()
                .resizable()
                .frame(width: 30, height: 30)
            Text(platformType.rawValue)
                .bold()
                .font(.system(size: 12))
                .foregroundStyle(.white)
        }
        .padding(.all, 4)
        .padding(.trailing, 8)
        .background(Capsule().fill(Color.black.opacity(0.8)))
        .padding([.top, .trailing], 10)
    }
    
    func platformLogo() -> Image {
        switch platformType {
        case .instagram:
            LoadifyAssets.instagram
        case .tiktok:
            LoadifyAssets.tiktok
        case .twitter:
            LoadifyAssets.twitter
        }
    }
}

#Preview {
    PlatformBadgeView(platformType: .instagram)
    PlatformBadgeView(platformType: .twitter)
    PlatformBadgeView(platformType: .tiktok)
}
