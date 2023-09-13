//
//  MenuButton.swift
//  
//
//  Created by Vishweshwaran on 30/10/22.
//

import SwiftUI
import FontKit

public struct MenuButton: View {
    
    public enum ArrowDirection: String {
        case up = "chevron.up"
        case right = "chevron.right"
        case down = "chevron.down"
        case left = "chevron.left"
    }
    
    private var title: String
    private var arrowDirection: ArrowDirection
    
    public init(title: String, arrowDirection: ArrowDirection = .down) {
        self.title = title
        self.arrowDirection = arrowDirection
    }
    
    public var body: some View {
        HStack {
            Text("\(title)")
                .font(.inter(.semibold(size: 16)))
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            Image(systemName: arrowDirection.rawValue)
                .font(.subheadline)
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: 56)
        .foregroundColor(LoadifyColors.greyText)
        .background(Color.black)
        .cornerRadius(10)
    }
}

struct SelectView_Previews: PreviewProvider {
    static var previews: some View {
        MenuButton(title: "Select Video Quality", arrowDirection: .down)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
