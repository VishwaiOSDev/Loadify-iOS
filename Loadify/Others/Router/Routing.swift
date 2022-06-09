//
//  Routing.swift
//  Loadify
//
//  Created by Vishweshwaran on 04/06/22.
//

import SwiftUI

protocol Routing {
    associatedtype Route
    associatedtype View: SwiftUI.View
    
    @ViewBuilder func view(for route: Route) -> Self.View
}
