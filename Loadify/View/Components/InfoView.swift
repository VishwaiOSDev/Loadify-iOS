//
//  InfoView.swift
//  Loadify
//
//  Created by Vishweshwaran on 02/06/22.
//

import SwiftUI
import LoadifyKit

struct InfoView: View {
    
    var title: String
    var subTitle: String
    
    var body: some View {
        VStack {
            Text("\(title)")
                .font(.headline)
                .fontWeight(.heavy)
                .lineLimit(1)
            Text("\(subTitle)")
                .font(.footnote)
                .foregroundColor(LoadifyColors.greyText)
        }
        .foregroundColor(.white)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(title: "31 lakh", subTitle: "Likes")
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
