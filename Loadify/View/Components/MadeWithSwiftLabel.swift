//
//  MadeWithSwiftLabel.swift
//  Loadify
//
//  Created by Vishweshwaran on 2023-11-23.
//

import SwiftUI
import FontKit

struct MadeWithSwiftLabel: View {
    
    var body: some View {
        Text("Made with 💙 using Swift")
            .font(.inter(.regular(size: 14)))
            .foregroundColor(LoadifyColors.greyText)
    }
}

#Preview {
    MadeWithSwiftLabel()
}
