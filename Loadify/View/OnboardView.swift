//
//  OnboardView.swift
//  Loadify
//
//  Created by Vishweshwaran on 21/06/22.
//

import SwiftUI

struct OnboardView: View {
    
    @AppStorage("OnboardingScreen") var isOnboardingScreenShown: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            onBoardTitle("What's new\n in Loadify")
                .padding(.bottom, 30)
            newFeatures
                .padding()
            Spacer()
            Button(action: didTapContinue) {
                Text("Continue")
            }
            .buttonStyle(CustomButtonStyle())
            .padding(.vertical, 30)
            .padding(.horizontal)
        }
        .padding()
    }
    
    private func onBoardTitle(_ title: String) -> some View {
        Text(title)
            .font(.largeTitle)
            .bold()
            .multilineTextAlignment(.center)
    }
    
    private var newFeatures: some View {
        VStack(alignment: .leading, spacing: 30) {
            NewFeatureCell(icon: "icloud.and.arrow.down.fill", title: "Download videos", subtitle: "Download your favourite YouTube videos")
            NewFeatureCell(icon: "rectangle.stack.badge.play.fill", title: "Choose video quality", subtitle: "Select your own video quality")
            NewFeatureCell(icon: "speedometer", title: "2x Faster Download", subtitle: "We improved the download speed")
        }
    }
    
    private func didTapContinue() {
        isOnboardingScreenShown = true
    }
}

fileprivate struct NewFeatureCell: View {
    
    fileprivate var icon: String
    fileprivate var title: String
    fileprivate var subtitle: String
    
    fileprivate var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(Colors.blue_accent)
                .frame(width: 35, height: 35)
            cellContentView
                .foregroundColor(.white)
        }
    }
    
    private var cellContentView: some View {
        VStack(alignment: .leading) {
            Text(title)
                .bold()
                .foregroundColor(.white)
                .lineLimit(nil)
            Text(subtitle)
                .foregroundColor(.gray)
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct OnboardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardView()
        }
        .preferredColorScheme(.dark)
    }
}
