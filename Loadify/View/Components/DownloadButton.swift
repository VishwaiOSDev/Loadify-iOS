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
    let progress: Binding<Double>?
    let isDisabled: Bool
    let showLoader: Bool
    let action: () -> Void
    
    init(
        _ label: String = "Download",
        progress: Binding<Double>? = nil,
        isDisabled: Bool,
        showLoader: Bool = false,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.progress = progress
        self.isDisabled = isDisabled
        self.showLoader = showLoader
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            DownloadButtonContent(label: label, progress: progress, showLoader: showLoader)
        }
        .buttonStyle(
            CustomButtonStyle(
                progress: progress.map { $0 },
                isDisabled: isDisabled ? true: false
            )
        )
        .disabled(isDisabled ? true: false)
        .disabled(shouldDisableButton)
    }
    
    private var shouldDisableButton: Bool {
        showLoader || (progress?.wrappedValue ?? 0.0 > 0.0 && progress?.wrappedValue ?? 0.0 < 1.0)
    }
}

fileprivate struct DownloadButtonContent: View {
    
    let label: String
    let progress: Binding<Double>?
    let showLoader: Bool
    
    var body: some View {
        ZStack {
            if showLoader {
                ProgressView()
                    .controlSize(.regular)
            } else {
                DownloadLabel(label: label, progress: progress)
            }
        }
    }
}

fileprivate struct DownloadLabel: View {
    
    let label: String
    let progress: Binding<Double>?
    
    var body: some View {
        if let currentProgress = progress?.wrappedValue, currentProgress > 0.0 && currentProgress < 1.0 {
            VStack(spacing: 4) {
                Text("Downloading...")
                    .font(.inter(.semibold(size: 16)))
                Text("Please keep the app open. This may take a moment.")
                    .font(.inter(.regular(size: 10)))
                    .opacity(0.8)
            }
        } else {
            Text(label)
                .font(.inter(.semibold(size: 16)))
        }
    }
}

#Preview {
    DownloadButton(progress: .constant(0.5), isDisabled: false, showLoader: false) { }
}
