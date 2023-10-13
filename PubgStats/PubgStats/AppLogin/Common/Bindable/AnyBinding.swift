//
//  AnyBinding.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/10/23.
//

import Foundation


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
