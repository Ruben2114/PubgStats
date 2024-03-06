//
//  SurvivalAttributesDetailsRepresentable.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 15/2/24.
//

import Foundation

enum AttributesDetailsSurvival {
    case airDropsCalled(SurvivalDataProfileRepresentable)
    case damageDealt(SurvivalDataProfileRepresentable)
    case damageTaken(SurvivalDataProfileRepresentable)
    case distanceBySwimming(SurvivalDataProfileRepresentable)
    case distanceByVehicle(SurvivalDataProfileRepresentable)
    case distanceOnFoot(SurvivalDataProfileRepresentable)
    case distanceTotal(SurvivalDataProfileRepresentable)
    case healed(SurvivalDataProfileRepresentable)
    case hotDropLandings(SurvivalDataProfileRepresentable)
    case enemyCratesLooted(SurvivalDataProfileRepresentable)
    case uniqueItemsLooted(SurvivalDataProfileRepresentable)
    case revived(SurvivalDataProfileRepresentable)
    case teammatesRevived(SurvivalDataProfileRepresentable)
    case timeSurvived(SurvivalDataProfileRepresentable)
    case throwablesThrown(SurvivalDataProfileRepresentable)
    
    static func getStatistics(_ stats: SurvivalDataProfileRepresentable) -> [AttributesDetailsSurvival] {
        return  [.airDropsCalled(stats),
                 .damageDealt(stats),
                 .damageTaken(stats),
                 .distanceBySwimming(stats),
                 .distanceByVehicle(stats),
                 .distanceOnFoot(stats),
                 .distanceTotal(stats),
                 .healed(stats),
                 .hotDropLandings(stats),
                 .enemyCratesLooted(stats),
                 .uniqueItemsLooted(stats),
                 .revived(stats),
                 .teammatesRevived(stats),
                 .timeSurvived(stats),
                 .throwablesThrown(stats)]
    }
    
    func getStats() -> (String, String) {
        switch self {
        case .airDropsCalled(let stat):
            return ("airDropsCalled", (stat.stats.airDropsCalled ?? ""))
        case .damageDealt(let stat):
            return ("damageDealt", (stat.stats.damageDealt ?? ""))
        case .damageTaken(let stat):
            return ("damageTaken", (stat.stats.damageTaken ?? ""))
        case .distanceBySwimming(let stat):
            return ("swimDistance", getDistance(stat.stats.distanceBySwimming ?? ""))
        case .distanceByVehicle(let stat):
            return ("rideDistance", getDistance(stat.stats.distanceByVehicle ?? ""))
        case .distanceOnFoot(let stat):
            return ("walkDistance", getDistance(stat.stats.distanceOnFoot ?? ""))
        case .distanceTotal(let stat):
            return ("distanceTotal", getDistance(stat.stats.distanceTotal))
        case .healed(let stat):
            return ("healing", (stat.stats.healed ?? ""))
        case .hotDropLandings(let stat):
            return ("hotDropLandings", (stat.stats.hotDropLandings ?? ""))
        case .enemyCratesLooted(let stat):
            return ("enemyCratesLooted", (stat.stats.enemyCratesLooted ?? ""))
        case .uniqueItemsLooted(let stat):
            return ("uniqueItemsLooted", (stat.stats.uniqueItemsLooted ?? ""))
        case .revived(let stat):
            return ("revives", (stat.stats.revived ?? ""))
        case .teammatesRevived(let stat):
            return ("teammatesRevived", (stat.stats.teammatesRevived ?? ""))
        case .timeSurvived(let stat):
            return ("timeSurvived", getTime(stat.stats.timeSurvived ?? ""))
        case .throwablesThrown(let stat):
            return ("throwablesThrown", (stat.stats.throwablesThrown ?? ""))
        }
    }
    
    func getTime(_ timeSurvived: String) -> String {
        let time = Double(timeSurvived) ?? 0
        let days = Int(round(time / 86400))
        let hours = Int(round((time.truncatingRemainder(dividingBy: 86400)) / 3600))
        return "\(days) d \(hours) h"
    }
    
    func getDistance(_ distance: String?) -> String {
        let distanceKM = (Double(distance ?? "") ?? 0) / 1000
        return String(format: "%.0f km", distanceKM)
    }
}
