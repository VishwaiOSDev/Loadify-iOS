//
//  InfoView.swift
//  Loadify
//
//  Created by Vishweshwaran on 02/06/22.
//

import SwiftUI

struct InfoView: View {
    
    var title: String
    var subTitle: String
    
    var body: some View {
        VStack {
            Text("\(title)")
                .font(.title2)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("\(subTitle)")
                .font(.footnote)
                .foregroundColor(Loadify.Colors.grey_text)
        }
        .foregroundColor(.white)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(title: "31 lakh", subTitle: "Likes")
            .previewLayout(.sizeThatFits)
    }
}
