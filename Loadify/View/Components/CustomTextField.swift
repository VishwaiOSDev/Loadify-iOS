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
            
            HStack {
                ZStack(alignment: .leading) {
                    Group {
                        if text.isEmpty {
                            Text("\(placeHolder)")
                                .font(.inter(.regular(size: 16)))
                                .foregroundColor(LoadifyColors.greyText)
                        }
                        
                        textFieldView
                            .disableAutocorrection(true)
                        
                        
                        
                    }.padding(.leading, 16)
                }
                
                if text.isEmpty {
                    Button(action: didTapOnPasteIcon, label: {
                        Image(systemName: "doc.on.clipboard")
                            .frame(maxHeight: .infinity)
                            .padding(.horizontal, 10)
                            .foregroundStyle(.white.opacity(0.8))
                    })
                } else {
                    Button(action: didTapClearIcon, label: {
                        Image(systemName: "xmark.circle.fill")
                            .frame(maxHeight: .infinity)
                            .padding(.horizontal, 10)
                            .foregroundStyle(.white)
                    })
                }
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
    
    private func didTapClearIcon() {
        text.removeAll()
    }
    
    private func didTapOnPasteIcon() {
        if UIPasteboard.general.hasStrings {
            text = UIPasteboard.general.string ?? ""
        }
    }
}

struct CustomTextField_Previews: PreviewProvider {
    
    static var previews: some View {
        CustomTextField("Enter YouTube or Instagram URL", text: .constant(""))
            .previewLayout(.sizeThatFits)
    }
}
