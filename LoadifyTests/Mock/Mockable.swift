//
//  Mockable.swift
//  LoadifyTests
//
//  Created by Vishweshwaran on 13/06/22.
//

import Foundation

protocol Mockable: AnyObject {
    var bundle: Bundle { get }
    func loadJSON<T: Decodable>(fileName: String, type: T.Type) throws -> T
}

extension Mockable {
    
    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }
    
    func loadJSON<T: Decodable>(fileName: String, type: T.Type) throws -> T {
        guard let path = bundle.url(forResource: fileName, withExtension: "json") else {
            throw URLError(.badURL)
        }
        do {
            let data = try Data(contentsOf: path)
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return decodedObject
        } catch {
            fatalError("Failed to decode the JSON.")
        }
    }
}
