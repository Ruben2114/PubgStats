//
//  ProfileEntity.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import Foundation

class ProfileEntity {
    var name: String
    var password: String
    var email: String
    var player: String?
    var account: String?
    var image: Data?
    init(name: String, password: String, email: String) {
        self.name = name
        self.password = password
        self.email = email
    }
    var weapons: [WeaponDTO]?
    var gameModes: [GamesModesDTO]?
    var weapon: String?
}
