//
//  Mockable.swift
//  LoadifyTests
//
//  Created by Vishweshwaran on 13/06/22.
//

import Foundation
import LogKit

protocol Mockable: AnyObject {
    var bundle: Bundle { get }
    func loadJSON<T: Codable>(fileName: String, type: T.Type) -> T
}

extension Mockable {
    
    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }
    
    func loadJSON<T: Codable>(fileName: String, type: T.Type) -> T {
        guard let path = bundle.url(forResource: fileName, withExtension: "json") else {
            fatalError("Failed to load JSON file.")
        }
        do {
            let data = try Data(contentsOf: path)
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return decodedObject
        } catch {
            Log.error(error)
            fatalError("Failed to decode the JSON.")
        }
    }
}
