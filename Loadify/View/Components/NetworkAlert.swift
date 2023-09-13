//
//  NetworkAlert.swift
//  
//
//  Created by Vishweshwaran on 24/09/22.
//

import Combine
import FontKit
#if canImport(SwiftUI)
import SwiftUI

public struct NetworkAlert: ViewModifier {
    
    @State private var isAlertShown: Bool = false
    
    private let isReachable: Bool
    private let message: String
    
    public init(isReachable: Bool, message: String) {
        self.isReachable = isReachable
        self.message = message
    }
    
    public func body(content: Content) -> some View {
        VStack {
            content
            if isAlertShown {
                toastView
                    .background(backgroundColor)
            }
        }
        .onReceive(Just(isReachable)) { toggleAlert(when: $0) }
        .animation(.linear(duration: 0.2))
    }
    
    private var toastView: some View {
        VStack {
            Text(message)
                .foregroundColor(.white)
                .font(.inter(.regular(size: 14)))
                .if(UIDevice.current.hasNotch) {
                    $0.padding(.bottom)
                }
        }
        .frame(maxWidth: .infinity, alignment: .top)
        .frame(height: 50)
    }
    
    private var backgroundColor: Color {
        message == "Back online" ? Color.green : Color.black
    }
    
    private func toggleAlert(when networkStatus: Bool) {
        guard isAlertShown == networkStatus else { return }
        if networkStatus {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation { isAlertShown = false }
            }
        } else {
            withAnimation { isAlertShown = true}
        }
    }
}

extension View {
    public func showNetworkAlert(when isReachable: Bool, with message: String) -> some View {
        modifier(NetworkAlert(isReachable: isReachable, message: message))
    }
}

struct NetworkAlert_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.blue.edgesIgnoringSafeArea(.all)
            Text("Hello World!")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .showNetworkAlert(when: true, with: "Back online")
    }
}
#endif

