//
//  CustomTextField.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/7/22.
//

import SwiftUI
import LoadifyKit

struct CustomTextField: View {
    
    @Binding var text: String
    var placeHolder: String
    
    init(
        _ placeHolder: String,
        text: Binding<String>
    ) {
        self.placeHolder = placeHolder
        self._text = text
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text("\(placeHolder)")
                        .foregroundColor(LoadifyColors.greyText)
                }
                textFieldView
                    .disableAutocorrection(true)
            }
            .frame(maxWidth: .infinity, maxHeight: 56)
            .padding(.horizontal, 16)
            .background(LoadifyColors.textfieldBackground)
            .cornerRadius(10)
        }
    }
    
    private var textFieldView: some View {
        TextField("", text: $text)
            .foregroundColor(.white)
            .autocapitalization(.none)
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField("Enter YouTube URL", text: .constant(""))
            .previewLayout(.sizeThatFits)
    }
}
