//
//  DownloadView.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/9/22.
//

import SwiftUI

struct DownloadView: View {
    
    var videoDetails: VideoDetails?
    
    var body: some View {
        ZStack {
            Loadify.Colors.app_background
                .edgesIgnoringSafeArea(.all)
            checkDetailsExists()
                .padding()
        }
    }
    
    @ViewBuilder
    private func checkDetailsExists() -> some View {
        if let videoDetails = videoDetails {
            constructBody(with: videoDetails)
        } else {
            ProgressView()
        }
    }
    
    @ViewBuilder
    private func constructBody(with details: VideoDetails) -> some View {
        VStack {
            
            Image(Loadify.Images.loadify_horizontal)
            Spacer()
            VStack {
                Text("\(details.title)")
                    .foregroundColor(.white)
                    .font(.title3)
                    .bold()
                    .lineLimit(2)
                VStack(alignment: .leading) {
                    Text("\(details.ownerChannelName)")
                        .foregroundColor(.white)
                        .font(.subheadline)
                    Text("\(String(describing: details.author.subscriberCount ?? 0)) Crore subscribers")
                        .font(.footnote)
                        .foregroundColor(Loadify.Colors.grey_text)
                }
            }
            Spacer()
            madeWithSwift
        }
    }
    
    private var madeWithSwift: some View {
        Text("Made with 💙 using Swift")
            .font(.footnote)
            .foregroundColor(Loadify.Colors.grey_text)
    }
}

//struct DownloadView_Previews: PreviewProvider {
//    static var previews: some View {
//        DownloadView()
//    }
//}
