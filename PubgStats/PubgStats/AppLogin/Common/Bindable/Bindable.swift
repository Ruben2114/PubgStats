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


@propertyWrapper
public struct AnyBinding<EnclosingType: DataBindable, Value> {
    
    public static subscript(
        _enclosingInstance instance: EnclosingType,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingType, Value>,
        storae storageKeyPath: ReferenceWritableKeyPath<EnclosingType, Self>) -> Value {
            get {
                return instance.dataBinding.get() ?? instance[keyPath: storageKeyPath].defaultValue
            }
            @available(*, unavailable)
            set {
                fatalError()
            }
        }
    
    @available(*, unavailable)
    public var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() }
    }
    
    let defaultValue: Value
    
    public init(defaultValue: Value) {
        self.defaultValue = defaultValue
    }
}

@propertyWrapper
public struct AnyBindingOptional<EnclosingType: DataBindable, Value: ExpressibleByNilLiteral> {
    
    public static subscript(
        _enclosingInstance instance: EnclosingType,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingType, Value>,
        storae storageKeyPath: ReferenceWritableKeyPath<EnclosingType, Self>) -> Value {
            get {
                return instance.dataBinding.get() ?? Value(nilLiteral: ())
            }
            @available(*, unavailable)
            set { fatalError() }
        }
    
    @available(*, unavailable)
    public var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() }
    }
    
    public init() {}
}
