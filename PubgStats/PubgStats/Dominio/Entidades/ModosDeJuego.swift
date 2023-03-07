//
//  ModosDeJuego.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 7/3/23.
//

import Foundation
struct ModosDeJuego: Decodable {
    private let data: DatosModosDeJuego
    var duo: Duo {
        data.attributes.gameModeStats.duo
    }
    var duoFpp: Duo {
        data.attributes.gameModeStats.duoFpp
    }
    var solo: Duo {
        data.attributes.gameModeStats.solo
    }
    var soloFpp: Duo {
        data.attributes.gameModeStats.soloFpp
    }
    var squad: Duo {
        data.attributes.gameModeStats.squad
    }
    var squadFpp: Duo {
        data.attributes.gameModeStats.squadFpp
    }
    var bestRank: Int {
        data.attributes.bestRankPoint
    }
    var muertesTotal: Int {
        let modelo = data.attributes.gameModeStats
        return modelo.duo.kills + modelo.duoFpp.kills + modelo.solo.kills + modelo.soloFpp.kills + modelo.squad.kills + modelo.squadFpp.kills
    }
    var top10STotal: Int {
        let modelo = data.attributes.gameModeStats
        return modelo.duo.top10S + modelo.duoFpp.top10S + modelo.solo.top10S + modelo.soloFpp.top10S + modelo.squad.top10S + modelo.squadFpp.top10S
    }
    var partidasTotal: Int {
        let modelo = data.attributes.gameModeStats
        return modelo.duo.roundsPlayed + modelo.duoFpp.roundsPlayed + modelo.solo.roundsPlayed + modelo.soloFpp.roundsPlayed + modelo.squad.roundsPlayed + modelo.squadFpp.roundsPlayed
    }
    var partidasGanadasTotal: Int {
        let modelo = data.attributes.gameModeStats
        return modelo.duo.wins + modelo.duoFpp.wins + modelo.solo.wins + modelo.soloFpp.wins + modelo.squad.wins + modelo.squadFpp.wins
    }
    var tiempoJugadoTotal: String {
        let modelo = data.attributes.gameModeStats
        let tiempo = modelo.duo.timeSurvived + modelo.duoFpp.timeSurvived + modelo.solo.timeSurvived + modelo.soloFpp.timeSurvived + modelo.squad.timeSurvived + modelo.squadFpp.timeSurvived
        let dias = tiempo / 86400
        let horas = (tiempo % 86400) / 3600
        let minutos = (tiempo % 3600) / 60
        return "\(dias) d \(horas) h \(minutos) m"
    }
}
struct DatosModosDeJuego: Decodable {
    let attributes: AtributosModosDeJuego
}
struct AtributosModosDeJuego: Decodable {
    let gameModeStats: EstadisticasModosDeJuego
    let bestRankPoint: Int
}
struct EstadisticasModosDeJuego: Decodable {
    let duo, duoFpp, solo, soloFpp: Duo
    let squad, squadFpp: Duo
    enum CodingKeys: String, CodingKey {
        case duo
        case duoFpp = "duo-fpp"
        case solo
        case soloFpp = "solo-fpp"
        case squad
        case squadFpp = "squad-fpp"
    }
}
struct Duo: Decodable {
    let assists, boosts, dBNOS, dailyKills: Int
    let dailyWINS: Int
    let damageDealt: Double
    let days, headshotKills, heals, killPoints: Int
    let kills: Int
    let longestKill: Double
    let longestTimeSurvived, losses, maxKillStreaks, mostSurvivalTime: Int
    let rankPoints: Int
    let rankPointsTitle: String
    let revives: Int
    let rideDistance: Double
    let roadKills, roundMostKills, roundsPlayed, suicides: Int
    let swimDistance: Double
    let teamKills, timeSurvived, top10S, vehicleDestroys: Int
    let walkDistance: Double
    let weaponsAcquired, weeklyKills, weeklyWINS, winPoints: Int
    let wins: Int
    enum CodingKeys: String, CodingKey {
        case assists, boosts
        case dBNOS = "dBNOs"
        case dailyKills
        case dailyWINS = "dailyWins"
        case damageDealt, days, headshotKills, heals, killPoints, kills, longestKill, longestTimeSurvived, losses, maxKillStreaks, mostSurvivalTime, rankPoints, rankPointsTitle, revives, rideDistance, roadKills, roundMostKills, roundsPlayed, suicides, swimDistance, teamKills, timeSurvived
        case top10S = "top10s"
        case vehicleDestroys, walkDistance, weaponsAcquired, weeklyKills
        case weeklyWINS = "weeklyWins"
        case winPoints, wins
    }
}
