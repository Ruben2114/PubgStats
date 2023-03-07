//
//  Weapon.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 7/3/23.
//

import Foundation
struct Weapon: Decodable {
    let data: DatosWeapon
}
struct DatosWeapon: Decodable {
    let attributes: AtributosWeapon
}
struct AtributosWeapon: Decodable {
    let weaponSummaries: [String: WeaponSummary]
}
struct WeaponSummary: Decodable {
    let xpTotal, levelCurrent, tierCurrent: Int
    let statsTotal: [String: Double]

    enum CodingKeys: String, CodingKey {
        case xpTotal = "XPTotal"
        case levelCurrent = "LevelCurrent"
        case tierCurrent = "TierCurrent"
        case statsTotal = "StatsTotal"
    }
}
