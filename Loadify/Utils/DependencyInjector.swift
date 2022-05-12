//
//  DependencyInjector.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/12/22.
//

import Foundation

public protocol InjectionKey {
    
    associatedtype Value
    
    static var currentValue: Self.Value { get set }
}

private struct DataServiceKey: InjectionKey {
    static var currentValue: DataService = ApiService()
}

extension InjectedValues {
    var apiSerice: DataService {
        get { Self[DataServiceKey.self] }
        set { Self[DataServiceKey.self] = newValue }
    }
}

struct InjectedValues {
    private static var current = InjectedValues()
    
    static subscript<K>(key: K.Type) -> K.Value where K: InjectionKey {
        get { key.currentValue }
        set { key.currentValue = newValue }
    }
    
    static subscript<T>(_ keyPath: WritableKeyPath<InjectedValues, T>) -> T {
        get { current[keyPath: keyPath] }
        set { current[keyPath: keyPath] = newValue }
    }
}

@propertyWrapper
struct Injected<T> {
    private let keyPath: WritableKeyPath<InjectedValues, T>
    var wrappedValue: T {
        get { InjectedValues[keyPath] }
        set { InjectedValues[keyPath] = newValue }
    }
    
    init(_ keyPath: WritableKeyPath<InjectedValues, T>) {
        self.keyPath = keyPath
    }
}
