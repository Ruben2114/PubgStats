//
//  Bindable.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 12/10/23.
//

import Foundation

public typealias DataBindingPredicate = (Any) -> Bool

public protocol DataBinding {
    func get<T>() -> T?
    func get<T>(_ predicate: DataBindingPredicate?) -> T?
    func set<T>(_ value: T)
    func contains<T>(_ type: T.Type) -> Bool
    func removeAll()
}

public protocol DataBindable {
    typealias Binding<Value> = AnyBinding<Self, Value>
    typealias BindingOptional<Value: ExpressibleByNilLiteral> = AnyBindingOptional<Self, Value>
    var dataBinding: DataBinding { get }
}

public protocol Bindable {
    var dataBinding: DataBinding { get }
    func set<T>(_ value: T) -> Self
    func removeAll()
}

public extension Bindable {
    func set<T>(_ value: T) -> Self {
        dataBinding.set(value)
        return self
    }
    
    func removeAll() {
        dataBinding.removeAll()
    }
}
