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
    var isDisabled: Bool = true
    
    init(
        buttonColor: Color = Loadify.Colors.blue_accent,
        cornerRadius: CGFloat = 10,
        isDisabled: Bool = true
    ) {
        self.buttonColor = buttonColor
        self.cornerRadius = cornerRadius
        self.isDisabled = isDisabled
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title3)
            .foregroundColor(isDisabled ? .white.opacity(0.5) : .white)
            .frame(maxWidth: .infinity, maxHeight: 56)
            .background(
                (configuration.isPressed || isDisabled) ? buttonColor.opacity(0.5) : buttonColor
            )
            .cornerRadius(cornerRadius)
    }
}
