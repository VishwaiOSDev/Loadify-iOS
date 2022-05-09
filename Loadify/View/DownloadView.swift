//
//  DownloadView.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/9/22.
//

import SwiftUI

struct DownloadView: View {
    
    var body: some View {
        ZStack {
            Loadify.Colors.app_background
                .edgesIgnoringSafeArea(.all)
            VStack {
                Image(Loadify.Images.loadify_horizontal)
                Spacer()
                VStack {
                    Text("Beast - Official Trailer | Thalapathy Vijay | Sun Pictures | Nelson | Anirudh | Pooja Hedge")
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                        .lineLimit(2)
                    VStack(alignment: .leading) {
                        Text("Sun TV")
                            .foregroundColor(.white)
                            .font(.subheadline)
                        Text("1.74 Crore subscribers")
                            .font(.footnote)
                            .foregroundColor(Loadify.Colors.grey_text)
                    }
                }
                Spacer()
                madeWithSwift
            }
            .padding()
        }
    }
    
    private var madeWithSwift: some View {
        Text("Made with 💙 using Swift")
            .font(.footnote)
            .foregroundColor(Loadify.Colors.grey_text)
    }
}

struct DownloadView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadView()
    }
}
