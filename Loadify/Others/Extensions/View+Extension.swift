//
//  View+Extensions.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/9/22.
//

import SwiftUI
import LoadifyKit

extension View {
    
    func embedInNavigation() -> some View {
        NavigationView { self }
    }
    
    func customAlert<T: View>(item: Binding<Error?>, content: (Error) -> T) ->  some View {
        ZStack {
            self.allowsHitTesting(item.wrappedValue != nil ? false : true)
            if let error = item.wrappedValue {
                content(error)
            }
        }
    }
    
    func customAlert<T: View>(isPresented: Binding<Bool>, content: () -> T) ->  some View {
        ZStack {
            self.allowsHitTesting(isPresented.wrappedValue ? false : true)
            if isPresented.wrappedValue {
                content()
            }
        }
    }
    
    func dismiss(delay: TimeInterval = 2.5, completion: @escaping () -> Void) -> some View {
        self.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                completion()
            }
        }
    }
    
    func cardView(color: Color, cornerRadius: CGFloat = 10) -> some View {
        modifier(CardView(color: color, cornerRadius: cornerRadius))
    }
}
