//
//  View+Extension.swift
//  Loadify
//
//  Created by Vishweshwaran on 2023-09-12.
//

import SwiftUI

extension View {
    
    func embedInNavigation() -> some View {
        NavigationView { self }
    }
    
    func cardView(color: Color, cornerRadius: CGFloat = 10) -> some View {
        modifier(CardView(color: color, cornerRadius: cornerRadius))
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
    
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(
        _ condition: @autoclosure () -> Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
    
    /// This will return a loader from LoaderKit.
    /// This functions helps you to present `Loader` on top of the View Hierarchy
    /// - Parameters:
    ///   - title: Title of the loader to be displayed.
    ///   - showOverlay: Bool property to add black background behind the loader when it is active. By default it is false
    ///   - isPresented: isPresented is used to toggle the loader's state
    func showLoader(
        _ title: String,
        shouldShowOverlay: Bool = false,
        isPresented: Binding<Bool>
    ) -> some View {
        ZStack {
            self.allowsHitTesting(!isPresented.wrappedValue)
            if isPresented.wrappedValue {
                Loader(title: title, showOverlay: shouldShowOverlay)
            }
        }
    }
    
    /// This will return an Alert from LoaderKit.
    /// This functions helps you to present `Alert` on top of the View Hierarchy
    /// - Parameters:
    ///   - item: Error item to be displayed.
    ///   - content: Closure to show `Alert` and display error message
    func showAlert<T: View>(item: Binding<Error?>, for duration: TimeInterval = 2.5, content: (Error) -> T) -> some View {
        ZStack {
            self.allowsHitTesting(item.wrappedValue != nil ? false : true)
            if let error = item.wrappedValue {
                content(error)
                    .dismiss(delay: duration) {
                        item.wrappedValue = nil
                    }
            }
        }
    }
    
    /// This will return an Alert from LoaderKit.
    /// This functions helps you to present `Alert` on top of the View Hierarchy
    /// - Parameters:
    ///   - item: Error item to be displayed.
    ///   - content: Closure to show `Alert` and display error message
    func showAlert<T: View>(item: Binding<String?>, for duration: TimeInterval = 2.5, content: (String) -> T) -> some View {
        ZStack {
            self.allowsHitTesting(item.wrappedValue != nil ? false : true)
            if let errorMessage = item.wrappedValue {
                content(errorMessage)
                    .dismiss(delay: duration) {
                        item.wrappedValue = nil
                    }
            }
        }
    }
    
    func permissionAlert(isPresented: Binding<Bool>) -> some View {
        let title = LoadifyTexts.photosAccessTitle
        let message = LoadifyTexts.photosAccessSubtitle
        
        return self.alert(title, isPresented: isPresented, actions: {
            Button("Cancel", role: .cancel) { }
            Button("Settings") {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
        }, message: {
            Text(message)
        })
    }
    
    func dismiss(delay: TimeInterval, completion: @escaping () -> Void) -> some View {
        self.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                completion()
            }
        }
    }
    
    /// Uses VisualEffectsView to blur the background beneath the views
    func loaderBackground(colors: [Color]? = nil) -> some View {
        modifier(LoaderBackground(colors: colors))
    }
    
    /// Limits the font size for selected lines
    func reduceFontSize(for line: Int) -> some View {
        modifier(FontReducer(line: line))
    }
    
    @ViewBuilder
    func scaleImageBasedOnDevice() -> some View {
        if Device.iPad {
            self.scaledToFill()
        } else {
            self.scaledToFit()
        }
    }
}
