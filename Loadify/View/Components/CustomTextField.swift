//
//  CustomTextField.swift
//
//
//  Created by Vishweshwaran on 30/10/22.
//

import SwiftUI
import FontKit

struct CustomTextField: View {
    
    @Binding var text: String
    var placeHolder: String
    
    init(_ placeHolder: String, text: Binding<String>) {
        self.placeHolder = placeHolder
        self._text = text
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .leading) {
                Group {
                    if text.isEmpty {
                        Text("\(placeHolder)")
                            .font(.inter(.regular(size: 16)))
                            .foregroundColor(LoadifyColors.greyText)
                    }
                    textFieldView
                        .disableAutocorrection(true)
                }
                .padding(.horizontal, 16)
            }
            .frame(maxWidth: Loadify.maxWidth, maxHeight: 56)
            .background(LoadifyColors.textfieldBackground)
            .cornerRadius(10)
        }
    }
    
    private var textFieldView: some View {
        TextField("", text: $text)
            .foregroundColor(.white)
            .font(.inter(.regular(size: 16)))
            .autocapitalization(.none)
    }
}

struct CustomTextField_Previews: PreviewProvider {
    
    static var previews: some View {
        CustomTextField("Enter YouTube URL", text: .constant(""))
            .previewLayout(.sizeThatFits)
    }
}

