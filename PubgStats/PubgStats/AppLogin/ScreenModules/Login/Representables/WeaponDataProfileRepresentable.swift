//
//  WeaponDataProfileRepresentable.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 15/10/23.
//

import Foundation

public protocol WeaponDataProfileRepresentable {
    var weaponSummaries: [WeaponSummaryRepresentable] { get }
}

public protocol WeaponSummaryRepresentable {
    var name: String { get }
    var xpTotal: Int { get }
    var levelCurrent: Int { get }
    var tierCurrent: Int { get }
    var statsTotal: [String: Double] { get }
}

struct DefaultWeaponDataProfileRepresentable: WeaponDataProfileRepresentable {
    var weaponSummaries: [WeaponSummaryRepresentable]
    
    init(_ data: WeaponDataDTO){
        weaponSummaries = data.attributes.weaponSummaries.compactMap { DefaultWeaponSummaryRepresentable($0) }
    }
    
    init(_ data: [Weapon]){
        weaponSummaries = data.compactMap { DefaultWeaponSummaryRepresentable($0) }
    }
}

struct DefaultWeaponSummaryRepresentable: WeaponSummaryRepresentable {
    var name: String
    var xpTotal: Int
    var levelCurrent: Int 
    var tierCurrent: Int
    var statsTotal: [String: Double]
    
    init(_ data: Dictionary<String, WeaponSummaryDTO>.Element){
        name = data.key
        xpTotal = data.value.xpTotal
        levelCurrent = data.value.levelCurrent
        tierCurrent = data.value.tierCurrent
        statsTotal = data.value.statsTotal
    }
    
    init(_ data: Weapon){
        name = data.name ?? ""
        xpTotal = Int(data.xp)
        levelCurrent = Int(data.level)
        tierCurrent = Int(data.tier)
        guard let modeData = data.data, let dataWeapon = try? PropertyListSerialization.propertyList(from: modeData, options: [],format: nil) as? [String: Double] else {
            statsTotal = [:]
            return
        }
        statsTotal = dataWeapon
    }
}
