//
//  ReachablityManager.swift
//  
//
//  Created by Vishweshwaran on 24/09/22.
//

import SwiftUI
import Network

public final class ReachablityManager: ObservableObject {
    
    @Published public var isConnected = true
    
    public var connectionDescription: String {
        isConnected ? "Back online" : "No connection"
    }
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "ReachablityManager")
    
    public init() {
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
