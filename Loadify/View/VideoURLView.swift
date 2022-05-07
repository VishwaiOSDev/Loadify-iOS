//
//  VideoURLView.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import SwiftUI

struct VideoURLView: View {
    
    @State private var url: String = ""
    
    var body: some View {
        ZStack {
            Loadify.Colors.app_background
                .edgesIgnoringSafeArea(.all)
            VStack {
                Image(Loadify.Images.loadify_icon)
                Text("We are the best Audio and Video downloader \n app ever")
                    .foregroundColor(Loadify.Colors.grey_text)
                    .multilineTextAlignment(.center)
                Spacer()
                VStack(spacing: 12) {
                    CustomTextField("Enter YouTube URL", text: $url)
                    Button(action: didTapContinue) {
                        Text("Continue")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: 56)
                            .background(Loadify.Colors.blue_accent)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 16)
                Spacer()
                termsOfService
            }.padding()
        }
    }
    
    private var termsOfService: some View {
        ZStack {
            Text("By continuing, you agree to our ") +
            Text("Privacy Policy")
                .bold()
                .foregroundColor(Loadify.Colors.blue_accent) +
            Text(" and \nour ") +
            Text("Terms of Service")
                .bold()
                .foregroundColor(Loadify.Colors.blue_accent)
        }
        .foregroundColor(Loadify.Colors.grey_text)
        .font(.subheadline)
    }
    
    func didTapContinue() {
        
    }
}

struct VideoURLView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VideoURLView()
                .previewDevice("iPhone 13 Pro Max")
                .previewDisplayName("iPhone 13 Pro Max")
            VideoURLView()
                .previewDevice("iPhone SE (3rd generation)")
                .previewDisplayName("iPhone SE")
        }
    }
}

struct Loadify {
    struct Colors {
        static let app_background = Color("app_background")
        static let grey_text = Color("grey_text")
        static let textfield_background = Color("textfield_background")
        static let blue_accent = Color("blue_accent")
    }
    
    struct Images {
        static let loadify_icon = "loadify_icon"
    }
}
