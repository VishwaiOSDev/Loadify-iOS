//
//  FontReducer.swift
//  
//
//  Created by Vishweshwaran on 11/06/22.
//

import SwiftUI

internal struct FontReducer: ViewModifier {

    let line: Int
    
    internal func body(content: Content) -> some View {
        content
            .lineLimit(line)
            .minimumScaleFactor(0.5)
    }
}
