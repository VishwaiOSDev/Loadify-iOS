//
//  CustomButtonStyle.swift
//
//
//  Created by Vishweshwaran on 30/10/22.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    
    var progress: Binding<Double>?
    var buttonColor: Color
    var cornerRadius: CGFloat = 10
    var isDisabled: Bool = false
    
    init(
        progress: Binding<Double>? = nil,
        buttonColor: Color = LoadifyColors.blueAccent,
        cornerRadius: CGFloat = 10,
        isDisabled: Bool = false
    ) {
        self.progress = progress
        self.buttonColor = buttonColor
        self.cornerRadius = cornerRadius
        self.isDisabled = isDisabled
    }
    
    func makeBody(configuration: Configuration) -> some View {
        let label = configuration.label
        let foregroundColor = isDisabled ? Color.white.opacity(0.5) : Color.white
        
        let button = label
            .foregroundColor(foregroundColor)
            .frame(maxWidth: Loadify.maxWidth, maxHeight: 56)
            .background(
                progress.map { ProgressBar(progress: $0.wrappedValue) }
                    .foregroundStyle(.green)
            )
            .background(isDisabled ? buttonColor.opacity(0.5) : buttonColor)
            .cornerRadius(cornerRadius)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .onChange(of: progress?.wrappedValue) {
                if $0 == 1.0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.progress?.wrappedValue = .zero
                    }
                }
            }
        
        return button
    }
}

fileprivate struct ProgressBar: Shape {
    
    var progress: CGFloat
    
    var animatableData: CGFloat {
        get { return progress }
        set { self.progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width * progress, y: 0))
        path.addLine(to: CGPoint(x: rect.width * progress, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        
        return path
    }
}

struct CustomButtonStyle_Previews: PreviewProvider {
    
    static var previews: some View {
        Button(action: {}) {
            Text("Download Now")
        }
        .padding()
        .buttonStyle(CustomButtonStyle(progress: .constant(0.2), isDisabled: false))
    }
}
