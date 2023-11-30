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
    var progess: Binding<Double>?
    let isDisabled: Bool
    let action: () -> Void
    
    init(
        _ label: String = "Download",
        progress: Binding<Double>? = nil,
        isDisabled: Bool,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.progess = progress
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.inter(.semibold(size: 16)))
        }
        .buttonStyle(
            CustomButtonStyle(
                progress: progess.map { $0 },
                isDisabled: isDisabled ? true: false
            )
        )
        .disabled(isDisabled ? true: false)
    }
}

#Preview {
    DownloadButton(progress: .constant(0.5), isDisabled: false) { }
}
