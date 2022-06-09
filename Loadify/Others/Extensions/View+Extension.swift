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
    
    func customLoader(_ title: String, isPresented: Binding<Bool>) -> some View {
        ZStack {
            self.allowsHitTesting(!isPresented.wrappedValue)
            if isPresented.wrappedValue {
                LoaderView(title: title)
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
}
