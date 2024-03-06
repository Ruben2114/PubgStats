//
//  SurvivalDTO.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

struct SurvivalDTO: Decodable {
    let data: SurvivalDataDTO
}
struct SurvivalDataDTO: Decodable {
    let id: String
    let attributes: SurvivalAttributesDTO
}
struct SurvivalAttributesDTO: Decodable {
    let totalMatchesPlayed: Int
    let stats: StatSurvivalDTO
    let xp, level: Int
    let lastMatchID: String
    enum CodingKeys: String, CodingKey {
        case totalMatchesPlayed, stats, xp, level
        case lastMatchID = "lastMatchId"
    }
}
struct StatSurvivalDTO: Decodable {
    let airDropsCalled, damageDealt, damageTaken, distanceBySwimming: AirDropsCalledDTO
    let distanceByVehicle, distanceOnFoot, distanceTotal, healed: AirDropsCalledDTO
    let hotDropLandings: HotDropLandingsDTO
    let enemyCratesLooted, uniqueItemsLooted, position, revived: AirDropsCalledDTO
    let teammatesRevived, timeSurvived, throwablesThrown: AirDropsCalledDTO
    let top10: HotDropLandingsDTO
}
struct AirDropsCalledDTO: Decodable {
    let total: Double?
    let average, careerBest, lastMatchValue: Double
}
struct HotDropLandingsDTO: Decodable {
    let total: Double
}
