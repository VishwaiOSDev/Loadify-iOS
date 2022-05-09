//
//  RoundedButtonStyle.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/9/22.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    
    var buttonColor: Color = Loadify.Colors.blue_accent
    var cornerRadius: CGFloat = 10
    
    init(buttonColor: Color = Loadify.Colors.blue_accent, cornerRadius: CGFloat = 10) {
        self.buttonColor = buttonColor
        self.cornerRadius = cornerRadius
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title3)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: 56)
            .background(configuration.isPressed ?  buttonColor.opacity(0.5) : buttonColor)
            .cornerRadius(cornerRadius)
    }
}
