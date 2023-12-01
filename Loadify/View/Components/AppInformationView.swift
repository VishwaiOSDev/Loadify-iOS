//
//  AppInformationView.swift
//  Loadify
//
//  Created by Vishweshwaran on 2023-12-01.
//

import SwiftUI
import FontKit

enum AppVersionProvider {
    
    static func appVersion(in bundle: Bundle = .main) -> String {
        guard let version = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            fatalError("CFBundleShortVersionString should not be missing from info dictionary")
        }
        return version
    }
    
    static func buildVersion(in bundle: Bundle = .main) -> String {
        guard let buildVersion = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
            fatalError("CFBundleVersion should not be missing from info dictionary")
        }
        return buildVersion
    }
}

struct AppInformationView: View {
    
    let version: String
    let buildVersion: String
    
    var body: some View {
        Text("Version: \(version) (\(buildVersion))")
            .font(.inter(.medium(size: 12)))
            .foregroundStyle(LoadifyColors.greyText)
            .opacity(0.6)
            .textSelection(.enabled)
    }
}

#Preview {
    AppInformationView(
        version: AppVersionProvider.appVersion(),
        buildVersion: AppVersionProvider.buildVersion()
    )
}
