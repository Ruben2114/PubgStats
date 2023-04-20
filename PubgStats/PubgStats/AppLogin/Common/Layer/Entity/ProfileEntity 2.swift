//
//  ProfileEntity.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

class ProfileEntity {
    var name: String
    var password: String
    var email: String
    var player: String?
    var account: String?
    init(name: String, password: String, email: String) {
        self.name = name
        self.password = password
        self.email = email
    }
    var survival: [SurvivalDTO]?
    var weapons: [WeaponDTO]?
    var gameModes: [GamesModesDTO]?
    var weapon: String?
}
