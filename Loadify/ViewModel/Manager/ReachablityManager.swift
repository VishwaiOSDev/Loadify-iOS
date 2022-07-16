//
//  ReachablityManager.swift
//  Loadify
//
//  Created by Vishweshwaran on 13/06/22.
//

import SwiftUI
import Network

final class ReachablityManager: ObservableObject {
    
    @Published var isConnected = true
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "ReachablityManager")
    
    var connectionDescription: String? {
        if !isConnected {
            return "It looks like you're not connected to the internet"
        }
        return nil
    }
    
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
