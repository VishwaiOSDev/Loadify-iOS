//
//  View+Extensions.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/9/22.
//

import SwiftUI

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
    
    func dismiss(delay: TimeInterval = 3, completion: @escaping () -> Void) -> some View {
        self.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                completion()
            }
        }
    }
}
