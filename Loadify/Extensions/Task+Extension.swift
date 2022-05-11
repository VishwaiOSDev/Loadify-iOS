//
//  Task+Extension.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/11/22.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Int) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}
