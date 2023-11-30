//
//  ProgressUI.swift
//  Loadify
//
//  Created by Vishweshwaran on 2023-11-29.
//

import SwiftUI
import FontKit

public struct ProgressUI: View {
    
    @State private var loadingFirstDot: Bool = false
    @State private var loadingSecondDot: Bool = false
    @State private var loadingThirdDot: Bool = false
    @Binding var value: Double
    
    let reloadScreen = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    public init(value: Binding<Double>) {
        self._value = value
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 4) {
                Text("Downloading")
                    .font(.inter(.bold(size: 20)))
                
                Circle()
                    .frame(width: 5, height: 5)
                    .offset(y: 6)
                    .opacity(loadingFirstDot ? 1 : 0)
                
                Circle()
                    .frame(width: 5, height: 5)
                    .offset(y: 6)
                    .opacity(loadingSecondDot ? 1 : 0)
                
                Circle()
                    .frame(width: 5, height: 5)
                    .offset(y: 6)
                    .opacity(loadingThirdDot ? 1 : 0)
            }.foregroundColor(.white)
            
            Text("Please keep the app open. This may take a moment.")
                .font(.inter(.medium(size: 14)))
                .foregroundColor(.white)
                .opacity(0.5)
            
            ProgressView(value: value)
                .progressViewStyle(LinearProgressViewStyle(tint: LoadifyColors.blueAccent))
                .frame(height: 8)
                .scaleEffect(x: 1, y: 2, anchor: .center)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .padding(.vertical, 10)
            
        }
        .padding(.all, 16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
        .onReceive(reloadScreen, perform: { _ in
            loadingTheDots()
        })
        .onAppear {
            loadingTheDots()
        }
        .preferredColorScheme(.dark)
    }
    
    func loadingTheDots() {
        withAnimation(.linear(duration: 0.2)) {
            loadingFirstDot = true
        }
        
        withAnimation(.linear(duration: 0.2).delay(0.2)) {
            loadingSecondDot = true
        }
        
        withAnimation(.linear(duration: 0.25).delay(0.4)) {
            loadingThirdDot = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.linear(duration: 0.2)) {
                loadingFirstDot = false
                loadingSecondDot = false
                loadingThirdDot = false
            }
        }
    }
}

struct ProgressUIModifier: ViewModifier {
    
    @Binding var value: Double

    let shouldShow: Bool
    
    func body(content: Content) -> some View {
        content
            .if(shouldShow, transform: { view in
                view.overlay(ProgressUI(value: $value))
            })
    }
}

extension View {
    
    public func showProgressBar(when shouldShow: Bool, progressValue: Binding<Double>) -> some View {
        modifier(ProgressUIModifier(value: progressValue, shouldShow: shouldShow))
    }
}

struct ProgressUI_Previews: PreviewProvider {
    
    static var previews: some View {
        ZStack {
            Color.blue.edgesIgnoringSafeArea(.all)
            VStack {
                Text("Loadify")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                LoadifyAssets.loadifyIcon
            }
        }
        .preferredColorScheme(.dark)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .showProgressBar(when: true, progressValue: .constant(0.50))
    }
}
