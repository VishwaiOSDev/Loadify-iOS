//
//  ShareExtensionView.swift
//  LoadifyShareExtension
//
//  Created by Cédric Bahirwe on 23/03/2024.
//

import SwiftUI

struct ShareExtensionView: View {
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(.white, LoadifyColors.successGreen)
                    .padding(.bottom, 40)
                
                Text(LoadifyTexts.shareExtensionTitle)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                Text(LoadifyTexts.shareExtensionSubtitle)
                    .font(.title3.weight(.regular))
                    .multilineTextAlignment(.center)
                    .opacity(0.8)
            }
            
            Spacer()
            
            LoadifyAssets.loadifyHorizontal
                .padding(.bottom, 40)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.appBackground)
        .foregroundStyle(.white)
    }
}

#Preview {
    ShareExtensionView(url: URL(string: "loadify://")!)
}
