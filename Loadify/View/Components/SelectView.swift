//
//  SelectView.swift
//  Loadify
//
//  Created by Vishweshwaran on 09/06/22.
//

import SwiftUI

struct SelectView: View {
    
    var title: String
    
    var body: some View {
        HStack {
            Text("\(title)")
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            Image(systemName: "chevron.down")
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: 56)
        .font(.subheadline)
        .foregroundColor(Loadify.Colors.grey_text)
        .background(Color.black)
        .cornerRadius(10)
    }
}

struct SelectView_Previews: PreviewProvider {
    static var previews: some View {
        SelectView(title: "Select Video Quality")
            .previewLayout(.sizeThatFits)
    }
}
