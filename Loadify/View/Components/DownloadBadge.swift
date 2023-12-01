//
//  DownloadBadge.swift
//  Loadify
//
//  Created by Vishweshwaran on 2023-11-23.
//

import SwiftUI

struct DownloadBadge: View {
    
    let downloadStatus: DownloadStatus
    let alignment: Alignment
    
    init(downloadStatus: DownloadStatus, alignment: Alignment = .leading) {
        self.downloadStatus = downloadStatus
        self.alignment = alignment
    }
    
    var body: some View {
        if downloadStatus == .downloaded || downloadStatus == .failed {
            HStack(spacing: 4) {
                Image(systemName: "arrow.down.circle.fill")
                
                Text(downloadStatus == .downloaded ? "Downloaded" : "Failed")
                    .font(.inter(.bold(size: 14)))
                    .padding(2)
                    .cornerRadius(4)
            }
            .padding(.all, 4)
            .foregroundColor(.white)
            .background(badgeColor)
            .cornerRadius(4)
            .frame(maxWidth: .infinity, alignment: alignment)
        }
    }
    
    private var badgeColor: Color {
        let status = downloadStatus
        return status == .downloaded ? LoadifyColors.successGreenGradient : LoadifyColors.errorRed
    }
}

#Preview {
    DownloadBadge(downloadStatus: .downloaded)
        .previewLayout(.sizeThatFits)
}
