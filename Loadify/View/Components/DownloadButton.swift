//
//  DownloadButton.swift
//  Loadify
//
//  Created by Vishweshwaran on 2023-11-24.
//

import SwiftUI
import FontKit

struct DownloadButton: View {
    
    let label: String
    let isDisabled: Bool
    let action: () -> Void
    
    init(label: String = "Download", isDisabled: Bool, action: @escaping () -> Void) {
        self.label = label
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.inter(.light(size: 16)))
        }
        .buttonStyle(CustomButtonStyle(isDisabled: isDisabled ? true: false))
        .disabled(isDisabled ? true: false)
    }
}

#Preview {
    DownloadButton(isDisabled: false) { }
}
