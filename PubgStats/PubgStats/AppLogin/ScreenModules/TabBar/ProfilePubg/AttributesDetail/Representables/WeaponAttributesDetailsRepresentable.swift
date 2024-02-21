//
//  WeaponAttributesDetailsRepresentable.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 21/2/24.
//

import Foundation

enum AttributesDetailsWeapon {
    case kills(AttributesWeaponDetailsRepresentable)
    case damagePlayer(AttributesWeaponDetailsRepresentable)
    case headShots(AttributesWeaponDetailsRepresentable)
    case groggies(AttributesWeaponDetailsRepresentable)
    
    case bestData(AttributesWeaponDetailsRepresentable)
    case details(AttributesWeaponDetailsRepresentable)
    
    static func getHeaderStatistics(_ stats: AttributesWeaponDetailsRepresentable) -> [AttributesDetailsWeapon] {
        return  [.details(stats),
                 .bestData(stats)]
    }
    
    static func getDetailsStatistics(_ stats: AttributesWeaponDetailsRepresentable) -> [AttributesDetailsWeapon] {
        return  [.kills(stats),
                 .damagePlayer(stats),
                 .headShots(stats),
                 .groggies(stats)]
    }
    
    func getHeader() -> (String, Double) {
        switch self {
        case .kills(let statistics):
            let amount = statistics.weaponDetails.statsTotal.filter{ $0.key == "Kills" }.map{$0.value}.first
            let percentage = getPercentage(statistic: amount, total: statistics.killsTotal)
            return ("\("Kills".localize()): \(String(format: "%.0f", percentage)) %", percentage)
        case .damagePlayer(let statistics):
            let amount = statistics.weaponDetails.statsTotal.filter{ $0.key == "DamagePlayer" }.map{$0.value}.first
            let percentage = getPercentage(statistic: amount, total: statistics.damagePlayerTotal)
            return ("\("DamagePlayer".localize()): \(String(format: "%.0f", percentage)) %", percentage)
        case .headShots(let statistics):
            let amount = statistics.weaponDetails.statsTotal.filter{ $0.key == "HeadShots" }.map{$0.value}.first
            let percentage = getPercentage(statistic: amount, total: statistics.headShotsTotal)
            return ("\("HeadShots".localize()): \(String(format: "%.0f", percentage)) %", percentage)
        case .groggies(let statistics):
            let amount = statistics.weaponDetails.statsTotal.filter{ $0.key == "Groggies" }.map{$0.value}.first
            let percentage = getPercentage(statistic: amount, total: statistics.groggiesTotal)
            return ("\("Groggies".localize()): \(String(format: "%.0f", percentage)) %", percentage)
        default:
            return ("", 0)
        }
    }
    
    private func getPercentage(statistic: Double?, total: Double?, optional: Bool = false) -> CGFloat {
        let percentage = statistic != 0 && total != 0 ? ((statistic ?? 0) / (total ?? 0)) : 0
        let optionalPercentage = optional ? percentage : percentage * 100
        return CGFloat(optionalPercentage)
    }
    
    func getDetails() -> [AttributesDetails] {
        switch self {
        case .details(let statistics):
            return statistics.weaponDetails.statsTotal
                .filter{$0.key.contains("InAGame")}
                .map {DefaultAttributesDetails(titleSection: "BestData".localize(),
                                               title: $0.key.localize(),
                                               amount: String(format: "%.0f", $0.value))}
        case .bestData(let statistics):
            return statistics.weaponDetails.statsTotal
                .filter{!$0.key.contains("InAGame")}
                .map {DefaultAttributesDetails(titleSection: "details".localize(),
                                               title: $0.key.localize(),
                                               amount: $0.key == "LongestDefeat" ? "\(String(format: "%.0f", $0.value)) m": String(format: "%.0f", $0.value))}
        default:
            return []
        }
    }
}
