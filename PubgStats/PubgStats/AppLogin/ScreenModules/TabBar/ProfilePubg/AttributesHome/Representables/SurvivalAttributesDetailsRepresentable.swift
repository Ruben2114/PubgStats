//
//  SurvivalAttributesDetailsRepresentable.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 15/2/24.
//

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
    case position(SurvivalDataProfileRepresentable)
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
                 .position(stats),
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
            return ("distanceBySwimming", (stat.stats.distanceBySwimming ?? ""))
        case .distanceByVehicle(let stat):
            return ("distanceByVehicle", (stat.stats.distanceByVehicle ?? ""))
        case .distanceOnFoot(let stat):
            return ("distanceOnFoot", (stat.stats.distanceOnFoot ?? ""))
        case .distanceTotal(let stat):
            return ("distanceTotal", (stat.stats.distanceTotal ?? ""))
        case .healed(let stat):
            return ("healed", (stat.stats.healed ?? ""))
        case .hotDropLandings(let stat):
            return ("hotDropLandings", (stat.stats.hotDropLandings ?? ""))
        case .enemyCratesLooted(let stat):
            return ("enemyCratesLooted", (stat.stats.enemyCratesLooted ?? ""))
        case .uniqueItemsLooted(let stat):
            return ("uniqueItemsLooted", (stat.stats.uniqueItemsLooted ?? ""))
        case .position(let stat):
            return ("position", (stat.stats.position ?? ""))
        case .revived(let stat):
            return ("revived", (stat.stats.revived ?? ""))
        case .teammatesRevived(let stat):
            return ("teammatesRevived", (stat.stats.teammatesRevived ?? ""))
        case .timeSurvived(let stat):
            return ("timeSurvived", (stat.stats.timeSurvived ?? ""))
        case .throwablesThrown(let stat):
            return ("throwablesThrown", (stat.stats.throwablesThrown ?? ""))
        }
    }
}
