//
//  Sequence+Extension.swift
//  Loadify
//
//  Created by Vishweshwaran on 2023-11-25.
//

import Foundation

extension Sequence {
    
    func asyncForEach(_ operation: (Element, Int) async throws -> Void) async rethrows {
        for (index, element) in self.enumerated() {
            try await operation(element, index)
        }
    }
}
