//
//  DataBindingObject.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 12/10/23.
//

import Foundation

public class DataBindingObject: DataBinding {
    private var values: [Any] = []
    
    public init() {}
    
    public func get<T>() -> T? {
        return getElement()
    }
    
    public func get<T>(_ predicate: DataBindingPredicate? = nil) -> T? {
        return getElement(predicate: predicate)
    }
    
    public func set<T>(_ value: T) {
        defer { self.values.append(value) }
        guard let index = values.firstIndex(where: { $0 is T || $0 is T? }) else { return }
        values.remove(at: index)
    }
    
    public func contains<T>(_ type: T.Type) -> Bool {
        return values.contains(where: { $0 is T || $0 is T? })
    }
    
    public func removeAll() {
        values.removeAll()
    }
}

private extension DataBindingObject {
    func getElement<T>(predicate: DataBindingPredicate? = nil) -> T? {
        let wherePredicate = predicate ?? { $0 is T || $0 is T? }
        guard let index = values.firstIndex(where: wherePredicate),
              let value = values[index] as? Optional<T> else {
            return nil
        }
        return value
    }
}
