//
//  ReachablityManager.swift
//  
//
//  Created by Vishweshwaran on 24/09/22.
//

import SwiftUI
import Network

final class ReachablityManager: ObservableObject {
    
    @Published var isConnected = true
    
    var connectionDescription: String {
        isConnected ? "Back online" : "No connection"
    }
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "ReachablityManager")
    
    init() {
        startMonitoring()
    }
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
