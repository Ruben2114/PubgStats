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
    var weaponSummaries: [String: WeaponSummaryDTO]
    
    enum CodingKeys: String, CodingKey {
        case weaponSummaries
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        weaponSummaries = try container.decode([String: WeaponSummaryDTO].self, forKey: .weaponSummaries)
        var modifiedDict: [String: WeaponSummaryDTO] = [:]
        let pref = "Item_Weapon_"
        let suf = "_C"
        for (key, value) in weaponSummaries {
            if key.hasPrefix(pref) {
                let keyWithoutPrefix = String(key.dropFirst(pref.count))
                if keyWithoutPrefix.hasSuffix(suf) {
                    let keyWithoutSuffix = String(keyWithoutPrefix.dropLast(suf.count))
                    modifiedDict[keyWithoutSuffix] = value
                }
            }
        }
        weaponSummaries = modifiedDict
    }
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
