//
//  ExtensionString.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 25/4/23.
//

import Foundation

extension String {
    func localize() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, comment: self)
    }
}
