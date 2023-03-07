//
//  Survival.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 7/3/23.
//

import Foundation
struct Survival: Decodable {
    let data: DatosSurvival
}
struct DatosSurvival: Decodable {
    let id: String
    let attributes: AtributosSurvival
}
struct AtributosSurvival: Decodable {
    let totalMatchesPlayed: Int
    let stats: StatSurvival
    let xp, level: Int
    let lastMatchID: String
    enum CodingKeys: String, CodingKey {
        case totalMatchesPlayed, stats, xp, level
        case lastMatchID = "lastMatchId"
    }
}
struct StatSurvival: Decodable {
    let airDropsCalled, damageDealt, damageTaken, distanceBySwimming: AirDropsCalled
    let distanceByVehicle, distanceOnFoot, distanceTotal, healed: AirDropsCalled
    let hotDropLandings: HotDropLandings
    let enemyCratesLooted, uniqueItemsLooted, position, revived: AirDropsCalled
    let teammatesRevived, timeSurvived, throwablesThrown: AirDropsCalled
    let top10: HotDropLandings
}
struct AirDropsCalled: Decodable {
    let total: Double?
    let average, careerBest, lastMatchValue: Double
}
struct HotDropLandings: Decodable {
    let total: Double
}
