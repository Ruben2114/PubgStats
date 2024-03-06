//
//  State.swift
//  PubgStats
//
//  Created by Ruben Rodriguez Cervigon on 5/7/23.
//

import Foundation
import Combine

private struct Case<AssociatedValue> {
    let label: String
    let value: AssociatedValue
}

public protocol State {
    func associatedValue<AssociatedValue>(mathing pattern: (AssociatedValue) -> Self) -> AssociatedValue?
}

public extension State {
    func associatedValue<AssociatedValue>(mathing pattern: (AssociatedValue) -> Self) -> AssociatedValue? {
        guard let decomposed: Case<AssociatedValue> = decompose(),
              let patternLabel = Mirror(reflecting: pattern(decomposed.value)).children.first?.label,
            decomposed.label == patternLabel
        else {
            return nil
        }
        return decomposed.value
    }
}

private extension State {
    var label: String {
        return Mirror(reflecting: self).children.first?.label ?? String(describing: self)
    }
    func decompose<AssociatedValue>() -> Case<AssociatedValue>? {
       for case let (label?, value) in Mirror(reflecting: self).children {
           if let result = (value as? AssociatedValue) ?? (Mirror(reflecting: value).children.first?.value as? AssociatedValue) {
               return Case(label: label, value: result)
           }
       }
       return nil
   }
}
