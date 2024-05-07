//
//  ExtensionString.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 25/4/23.
//

import Foundation

enum Placeholder: String {
    case number = "{{NUMBER}}"
    case name = "{{NAME}}"
}

extension String {
    func localize() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, comment: self)
    }
    
    func placeholderString(replace: Placeholder, value: String) -> String {
        self.replacingOccurrences(of: replace.rawValue, with: value, range: self.range(of: replace.rawValue))
    }
}
