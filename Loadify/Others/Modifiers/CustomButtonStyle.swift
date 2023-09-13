//
//  CustomButtonStyle.swift
//  
//
//  Created by Vishweshwaran on 30/10/22.
//

import SwiftUI

public struct CustomButtonStyle: ButtonStyle {
    
    var buttonColor: Color
    var cornerRadius: CGFloat = 10
    var isDisabled: Bool = false
    
    public init(
        buttonColor: Color = LoadifyColors.blueAccent,
        cornerRadius: CGFloat = 10,
        isDisabled: Bool = false
    ) {
        self.buttonColor = buttonColor
        self.cornerRadius = cornerRadius
        self.isDisabled = isDisabled
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(isDisabled ? .white.opacity(0.5) : .white)
            .frame(maxWidth: .infinity, maxHeight: 56)
            .background(isDisabled ? buttonColor.opacity(0.5) : buttonColor)
            .cornerRadius(cornerRadius)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

struct CustomButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {}) {
            Text("Download Now")
        }
        .padding()
        .buttonStyle(CustomButtonStyle(isDisabled: false))
    }
}
