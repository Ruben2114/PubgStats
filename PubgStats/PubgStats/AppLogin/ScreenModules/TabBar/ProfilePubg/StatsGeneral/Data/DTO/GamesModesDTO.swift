//
//  GamesModesDTO.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//
import Foundation

struct GamesModesDTO: Decodable {
    private let data: GamesModesDataDTO
    var duo: DuoDTO {
        data.attributes.gameModeStats.duo
    }
    var duoFpp: DuoDTO {
        data.attributes.gameModeStats.duoFpp
    }
    var solo: DuoDTO {
        data.attributes.gameModeStats.solo
    }
    var soloFpp: DuoDTO {
        data.attributes.gameModeStats.soloFpp
    }
    var squad: DuoDTO {
        data.attributes.gameModeStats.squad
    }
    var squadFpp: DuoDTO {
        data.attributes.gameModeStats.squadFpp
    }
    var bestRank: Double {
        data.attributes.bestRankPoint
    }
    var killsTotal: Int {
        let model = data.attributes.gameModeStats
        return model.duo.kills + model.duoFpp.kills + model.solo.kills + model.soloFpp.kills + model.squad.kills + model.squadFpp.kills
    }
    var assistsTotal: Int {
        let model = data.attributes.gameModeStats
        return model.duo.assists + model.duoFpp.assists + model.solo.assists + model.soloFpp.assists + model.squad.assists + model.squadFpp.assists
    }
    var gamesPlayed: Int {
        let model = data.attributes.gameModeStats
        return model.duo.roundsPlayed + model.duoFpp.roundsPlayed + model.solo.roundsPlayed + model.soloFpp.roundsPlayed + model.squad.roundsPlayed + model.squadFpp.roundsPlayed
    }
    var wonTotal: Int {
        let model = data.attributes.gameModeStats
        return model.duo.wins + model.duoFpp.wins + model.solo.wins + model.soloFpp.wins + model.squad.wins + model.squadFpp.wins
    }
    var top10STotal: Int {
        let model = data.attributes.gameModeStats
        return model.duo.top10S + model.duoFpp.top10S + model.solo.top10S + model.soloFpp.top10S + model.squad.top10S + model.squadFpp.top10S
    }
    var headshotKillsTotal: Int {
        let model = data.attributes.gameModeStats
        return model.duo.headshotKills + model.duoFpp.headshotKills + model.solo.headshotKills + model.soloFpp.headshotKills + model.squad.headshotKills + model.squadFpp.headshotKills
    }
    var timePlayed: String {
        let model = data.attributes.gameModeStats
        let time = model.duo.timeSurvived + model.duoFpp.timeSurvived + model.solo.timeSurvived + model.soloFpp.timeSurvived + model.squad.timeSurvived + model.squadFpp.timeSurvived
        let days = Int(round(time / 86400))
        let hours = Int(round((time.truncatingRemainder(dividingBy: 86400)) / 3600))
        let minutes = Int(round((time.truncatingRemainder(dividingBy: 3600)) / 60))
        return "\(days) d \(hours) h \(minutes) m"
    }
}
struct GamesModesDataDTO: Decodable {
    let attributes: GamesModesAttributesDTO
}
struct GamesModesAttributesDTO: Decodable {
    let gameModeStats: StatisticsGameModes
    let bestRankPoint: Double
}
struct StatisticsGameModes: Decodable {
    let duo, duoFpp, solo, soloFpp: DuoDTO
    let squad, squadFpp: DuoDTO
    enum CodingKeys: String, CodingKey {
        case duo
        case duoFpp = "duo-fpp"
        case solo
        case soloFpp = "solo-fpp"
        case squad
        case squadFpp = "squad-fpp"
    }
}
struct DuoDTO: Decodable {
    let assists, boosts, dBNOS, dailyKills: Int
    let dailyWINS: Int
    let damageDealt: Double
    let days, headshotKills, heals: Int
    let kills: Int
    let longestKill: Double
    let losses, maxKillStreaks: Int
    let timeSurvived, mostSurvivalTime: Double
    let revives: Int
    let rideDistance: Double
    let roadKills, roundMostKills, roundsPlayed, suicides: Int
    let swimDistance: Double
    let teamKills, top10S, vehicleDestroys: Int
    let walkDistance: Double
    let weaponsAcquired, weeklyKills, weeklyWINS: Int
    let wins: Int
    enum CodingKeys: String, CodingKey {
        case assists, boosts
        case dBNOS = "dBNOs"
        case dailyKills
        case dailyWINS = "dailyWins"
        case damageDealt, days, headshotKills, heals, kills, longestKill, losses, maxKillStreaks, mostSurvivalTime, revives, rideDistance, roadKills, roundMostKills, roundsPlayed, suicides, swimDistance, teamKills, timeSurvived
        case top10S = "top10s"
        case vehicleDestroys, walkDistance, weaponsAcquired, weeklyKills
        case weeklyWINS = "weeklyWins"
        case wins
    }
}
