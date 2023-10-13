//
//  AnyBindingOptional.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/10/23.
//

import Foundation

@propertyWrapper
public struct AnyBindingOptional<EnclosingType: DataBindable, Value: ExpressibleByNilLiteral> {
    
    public static subscript(
        _enclosingInstance instance: EnclosingType,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingType, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingType, Self>) -> Value {
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
