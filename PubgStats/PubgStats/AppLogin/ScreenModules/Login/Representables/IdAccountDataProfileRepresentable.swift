//
//  IdAccountDataProfile.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 12/10/23.
//

import Foundation

public protocol IdAccountDataProfileRepresentable {
    var id: String { get }
    var name: String { get }
    var platform: String { get }
}

struct DefaultIdAccountDataProfileRepresentable: IdAccountDataProfileRepresentable {
    var id: String
    var name: String
    var platform: String
    
    init(id: String, name: String, platform: String) {
        self.id = id
        self.name = name
        self.platform = platform
    }
}
