//
//  SurvivalDataProfile.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/10/23.
//

import Foundation

public protocol SurvivalDataProfileRepresentable {
    var totalMatchesPlayed: String { get }
    var stats: StatSurvival { get }
    var xp: String { get }
    var level: String { get }
}

public protocol StatSurvival {
    var airDropsCalled: String? { get }
    var damageDealt: String? { get }
    var damageTaken: String? { get }
    var distanceBySwimming: String? { get }
    var distanceByVehicle: String? { get }
    var distanceOnFoot: String? { get }
    var distanceTotal: String? { get }
    var healed: String? { get }
    var hotDropLandings: String? { get }
    var enemyCratesLooted: String? { get }
    var uniqueItemsLooted: String? { get }
    var position: String? { get }
    var revived: String? { get }
    var teammatesRevived: String? { get }
    var timeSurvived: String? { get }
    var throwablesThrown: String? { get }
    var top10: String? { get }
}

public protocol AirDropsCalled {
    var total: Double? { get }
    var average: Double { get }
    var careerBest: Double { get }
    var lastMatchValue: Double { get }
}

struct DefaultSurvivalDataProfile: SurvivalDataProfileRepresentable {
    var totalMatchesPlayed: String
    var stats: StatSurvival
    var xp: String
    var level: String
    
    init(_ data: SurvivalAttributesDTO) {
        totalMatchesPlayed = String(data.totalMatchesPlayed)
        xp = String(data.xp)
        level = String(data.level)
        stats = DefaultStatSurvival(data.stats)
    }
    
    init(_ data: Survival) {
        totalMatchesPlayed = data.totalMatchesPlayed ?? ""
        xp = data.xp ?? ""
        level = data.level ?? ""
        stats = DefaultStatSurvival(data)
    }
}

struct DefaultStatSurvival: StatSurvival {
    var airDropsCalled: String?
    var damageDealt: String?
    var damageTaken: String?
    var distanceBySwimming: String?
    var distanceByVehicle: String?
    var distanceOnFoot: String?
    var distanceTotal: String?
    var healed: String?
    var hotDropLandings: String?
    var enemyCratesLooted: String?
    var uniqueItemsLooted: String?
    var position: String?
    var revived: String?
    var teammatesRevived: String?
    var timeSurvived: String?
    var throwablesThrown: String?
    var top10: String?
    
    init(_ data: StatSurvivalDTO) {
        hotDropLandings = String(data.hotDropLandings.total)
        top10 = String(data.top10.total)
        airDropsCalled = String(format: "%.0f", data.airDropsCalled.total ?? 0)
        damageDealt = String(format: "%.0f", data.damageDealt.total ?? 0)
        damageTaken = String(format: "%.0f", data.damageTaken.total ?? 0)
        distanceBySwimming = String(format: "%.0f", data.distanceBySwimming.total ?? 0)
        distanceByVehicle = String(format: "%.0f", data.distanceByVehicle.total ?? 0)
        distanceOnFoot = String(format: "%.0f", data.distanceOnFoot.total ?? 0)
        distanceTotal = String(format: "%.0f", data.distanceTotal.total ?? 0)
        healed = String(format: "%.0f", data.healed.total ?? 0)
        enemyCratesLooted = String(format: "%.0f", data.enemyCratesLooted.total ?? 0)
        uniqueItemsLooted = String(format: "%.0f", data.uniqueItemsLooted.total ?? 0)
        position = String(format: "%.0f", data.position.total ?? 0)
        revived = String(format: "%.0f", data.revived.total ?? 0)
        teammatesRevived = String(format: "%.0f", data.teammatesRevived.total ?? 0)
        timeSurvived = String(format: "%.0f", data.timeSurvived.total ?? 0)
        throwablesThrown = String(format: "%.0f", data.throwablesThrown.total ?? 0)
    }
    
    init(_ data: Survival) {
        hotDropLandings = data.hotDropLandings
        top10 = data.top10
        airDropsCalled = data.airDropsCalled
        damageDealt = data.damageDealt
        damageTaken = data.damageTaken
        distanceBySwimming = data.distanceBySwimming
        distanceByVehicle = data.distanceByVehicle
        distanceOnFoot = data.distanceOnFoot
        distanceTotal = data.distanceTotal
        healed = data.healed
        enemyCratesLooted = data.enemyCratesLooted
        uniqueItemsLooted = data.uniqueItemsLooted
        position = data.position
        revived = data.revived
        teammatesRevived = data.teammatesRevived
        timeSurvived = data.timeSurvived
        throwablesThrown = data.throwablesThrown
    }
}
