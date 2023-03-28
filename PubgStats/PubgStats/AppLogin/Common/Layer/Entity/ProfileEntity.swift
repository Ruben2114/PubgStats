//
//  ProfileEntity.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

class ProfileEntity {
    var name: String
    var password: String
    var player: String?
    var account: String?
    init(name: String, password: String) {
        self.name = name
        self.password = password
    }
    var survival: [SurvivalDTO]?
    var weapons: [WeaponDTO]?
    var gameModes: [GamesModesDTO]?
    var weapon: String?
}
