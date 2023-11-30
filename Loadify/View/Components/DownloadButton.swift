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
    let showLoader: Bool
    let isDisabled: Bool
    let downloadFailed: Bool
    let action: () -> Void
    
    init(
        _ label: String = "Download",
        progress: Binding<Double>? = nil,
        showLoader: Bool = false,
        isDisabled: Bool,
        downloadFailed: Bool = false,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.progress = progress
        self.showLoader = showLoader
        self.isDisabled = isDisabled
        self.downloadFailed = downloadFailed
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            DownloadButtonContent(
                label: label,
                progress: progress,
                showLoader: showLoader
            )
        }
        .buttonStyle(
            CustomButtonStyle(
                progress: progress.map { $0 },
                isDisabled: isDisabled ? true: false,
                downloadFailed: downloadFailed
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
                    .tint(LoadifyColors.textfieldBackground)
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
        let (title, message) = downloadLabelText
        
        VStack(spacing: 4) {
            Text(title)
                .font(.inter(.semibold(size: 16)))
            
            if let message {
                Text(message)
                    .font(.inter(.regular(size: 12)))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .opacity(0.8)
            }
        }
    }
    
    private var downloadLabelText: (String, String?) {
        if let currentProgess = progress?.wrappedValue {
            switch currentProgess {
            case 0.001..<1.0:
                return ("Downloading...", "Please keep the app open. This may take a moment")
            case 1.0:
                return ("Downloaded Successfully", nil)
            default:
                break
            }
        }
        
        return (label, nil)
    }
}

#Preview {
    DownloadButton(
        progress: .constant(
            0.3
        ),
        showLoader: false,
        isDisabled: false,
        downloadFailed: true
    ) { }
}
