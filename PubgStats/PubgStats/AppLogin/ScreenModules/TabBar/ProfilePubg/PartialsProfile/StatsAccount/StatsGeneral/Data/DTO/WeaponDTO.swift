//
//  WeaponDTO.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

struct WeaponDTO: Decodable {
    let data: WeaponDataDTO
}
struct WeaponDataDTO: Decodable {
    let attributes: WeaponAttributesDTO
}
struct WeaponAttributesDTO: Decodable {
    let weaponSummaries: [String: WeaponSummaryDTO]
}
struct WeaponSummaryDTO: Decodable {
    let xpTotal, levelCurrent, tierCurrent: Int
    let statsTotal: [String: Double]

    enum CodingKeys: String, CodingKey {
        case xpTotal = "XPTotal"
        case levelCurrent = "LevelCurrent"
        case tierCurrent = "TierCurrent"
        case statsTotal = "StatsTotal"
    }
}
