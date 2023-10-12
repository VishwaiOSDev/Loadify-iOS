//
//  CardView.swift
//
//
//  Created by Vishweshwaran on 30/10/22.
//

import SwiftUI

struct CardView: ViewModifier {
    
    private let color: Color
    private let cornerRadius: CGFloat
    
    init(color: Color, cornerRadius: CGFloat = 10) {
        self.color = color
        self.cornerRadius = cornerRadius
    }
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: Loadify.maxWidth)
            .if(Device.iPad) {
                $0.frame(maxHeight: 650)
            }
            .background(color)
            .cornerRadius(cornerRadius)
    }
}

struct CardView_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack {
            Text("Card View")
                .font(.largeTitle)
        }
        .padding()
        .modifier(CardView(color: LoadifyColors.blueAccent))
    }
}
