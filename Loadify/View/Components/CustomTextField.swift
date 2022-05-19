//
//  CustomTextField.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import SwiftUI

struct CustomTextField: View {
    
    @Binding var showError: Bool
    @Binding var text: String
    var placeHolder: String
    var errorMessage: String
    
    init(
        _ placeHolder: String,
        text: Binding<String>,
        showError: Binding<Bool> = .constant(false),
        errorMessage: String = ""
    ) {
        self.placeHolder = placeHolder
        self._showError = showError
        self.errorMessage = errorMessage
        self._text = text
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text("\(placeHolder)")
                        .foregroundColor(Loadify.Colors.grey_text)
                }
                TextField("", text: $text)
                    .foregroundColor(.white)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            .frame(maxWidth: .infinity, maxHeight: 56)
            .padding(.horizontal, 16)
            .background(Loadify.Colors.textfield_background)
            .cornerRadius(10)
            errorTextView
                .padding(.horizontal, 8)
        }
    }
    
    @ViewBuilder
    private var errorTextView: some View {
        if showError {
            Text("\(errorMessage)")
                .font(.subheadline)
                .foregroundColor(.red)
        }
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField("Enter YouTube URL", text: .constant(""))
            .previewLayout(.sizeThatFits)
    }
}
