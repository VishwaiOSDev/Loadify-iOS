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
    var isDisabled: Bool
    var downloadFailed: Bool
    
    init(
        progress: Binding<Double>? = nil,
        buttonColor: Color = LoadifyColors.blueAccent,
        cornerRadius: CGFloat = 10,
        isDisabled: Bool = false,
        downloadFailed: Bool = false
    ) {
        self.progress = progress
        self.buttonColor = buttonColor
        self.cornerRadius = cornerRadius
        self.isDisabled = isDisabled
        self.downloadFailed = downloadFailed
    }
    
    func makeBody(configuration: Configuration) -> some View {
        let label = configuration.label
        let foregroundColor = isDisabled ? Color.white.opacity(0.5) : Color.white
        
        let button = label
            .foregroundColor(foregroundColor)
            .frame(maxWidth: Loadify.maxWidth, maxHeight: 56)
            .background(downloadFailed ? LoadifyColors.errorRed : Color.clear)
            .background(
                progress.map { ProgressBar(progress: $0.wrappedValue) }
                    .foregroundStyle(LoadifyColors.successGreen)
            )
            .background(isDisabled ? buttonColor.opacity(0.5) : buttonColor)
            .cornerRadius(cornerRadius)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .onChange(of: progress?.wrappedValue) { oldValue, newValue in
                guard let newValue else { return }
                if newValue == 1.0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
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
        .buttonStyle(
            CustomButtonStyle(
                progress: .constant(0.2),
                isDisabled: false,
                downloadFailed: true
            )
        )
    }
}

