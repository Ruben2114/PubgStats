//
//  DataGeneralPlayerRepresentable.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 12/10/23.
//

import Foundation

public protocol IdAccountDataProfile {
    var id: String? { get }
    var name: String? { get }
}

struct DefaultIdAccountDataProfile: IdAccountDataProfile {
    var id: String?
    var name: String?
    
    init(id: String? = nil, name: String? = nil) {
        self.id = id
        self.name = name
    }
}
