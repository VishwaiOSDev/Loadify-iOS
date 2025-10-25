//
//  PlatformBadgeView.swift
//  Loadify
//
//  Created by Vishweshwaran on 2025-09-17.
//

import SwiftUI
import LoadifyEngine

extension Double {
    
    var clean: String {
        return String(format: "%.1f", self)
    }
}

struct PlatformBadgeView: View {
    
    let platformType: Platform
    let fileSize: Double?
    
    init(platformType: Platform, fileSize: Double? = nil) {
        self.platformType = platformType
        self.fileSize = fileSize
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            platformLogo()
                .resizable()
                .frame(width: 30, height: 30)
            VStack(alignment: .leading, spacing: 2) {
                Text(platformType.rawValue)
                    .font(.inter(.bold(size: 12)))
                    .foregroundStyle(.white)
                if let fileSize {
                    Text("\(fileSize.clean) MB")
                        .font(.inter(.medium(size: 9)))
                        .foregroundStyle(.gray)
                }
            }
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
        case .facebook:
            LoadifyAssets.facebook
        case .linkedin:
            LoadifyAssets.linkedin
        @unknown default:
            Image(systemName: "questionmark.circle")
        }
    }
}

#Preview {
    PlatformBadgeView(platformType: .instagram, fileSize: 78.28586673736572)
    PlatformBadgeView(platformType: .twitter)
    PlatformBadgeView(platformType: .tiktok)
}
