//
//  GamesModesDataProfileRepresentable.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/10/23.
//

import Foundation

public protocol GamesModesDataProfileRepresentable {
    var duo: StatisticsGameModesRepresentable { get }
    var duoFpp: StatisticsGameModesRepresentable { get }
    var solo: StatisticsGameModesRepresentable { get }
    var soloFpp: StatisticsGameModesRepresentable { get }
    var squad: StatisticsGameModesRepresentable { get }
    var squadFpp: StatisticsGameModesRepresentable { get }
    var bestRankPoint: String? { get }
    var killsTotal: String { get }
    var assistsTotal: String { get }
    var gamesPlayed: String { get }
    var wonTotal: String { get }
    var top10STotal: String { get }
    var headshotKillsTotal: String { get }
    var timePlayed: String { get }
    //TODO: ver que variables las queremos como totales por si quiero mas
}

public protocol StatisticsGameModesRepresentable {
    var assists: String { get }
    var boosts: String { get }
    var dBNOS: String { get }
    var dailyKills: String { get }
    var dailyWINS: String { get }
    var damageDealt: String { get }
    var days: String { get }
    var headshotKills: String { get }
    var heals: String { get }
    var kills: String { get }
    var longestKill: String { get }
    var losses: String { get }
    var maxKillStreaks: String { get }
    var timeSurvived: String { get }
    var mostSurvivalTime: String { get }
    var revives: String { get }
    var rideDistance: String { get }
    var roadKills: String { get }
    var roundMostKills: String { get }
    var roundsPlayed: String { get }
    var suicides: String { get }
    var swimDistance: String { get }
    var teamKills: String { get }
    var top10S: String { get }
    var vehicleDestroys: String { get }
    var walkDistance: String { get }
    var weaponsAcquired: String { get }
    var weeklyKills: String { get }
    var weeklyWINS: String { get }
    var wins: String { get }
}

struct DefaultGamesModesDataProfileRepresentable: GamesModesDataProfileRepresentable {
    var duo: StatisticsGameModesRepresentable
    var duoFpp: StatisticsGameModesRepresentable
    var solo: StatisticsGameModesRepresentable
    var soloFpp: StatisticsGameModesRepresentable
    var squad: StatisticsGameModesRepresentable
    var squadFpp: StatisticsGameModesRepresentable
    var bestRankPoint: String?
    var killsTotal: String
    var assistsTotal: String
    var gamesPlayed: String
    var wonTotal: String
    var top10STotal: String
    var headshotKillsTotal: String
    var timePlayed: String
    
    init(_ data: GamesModesDTO) {
        duo = DefaultStatisticsGameModesRepresentable(data.duo)
        duoFpp = DefaultStatisticsGameModesRepresentable(data.duoFpp)
        solo = DefaultStatisticsGameModesRepresentable(data.solo)
        soloFpp = DefaultStatisticsGameModesRepresentable(data.soloFpp)
        squad = DefaultStatisticsGameModesRepresentable(data.squad)
        squadFpp = DefaultStatisticsGameModesRepresentable(data.squadFpp)
        bestRankPoint = String(format: "%.0f", data.bestRank)
        killsTotal = String(data.killsTotal)
        assistsTotal = String(data.assistsTotal)
        gamesPlayed = String(data.gamesPlayed)
        wonTotal = String(data.wonTotal)
        top10STotal = String(data.top10STotal)
        headshotKillsTotal = String(data.headshotKillsTotal)
        timePlayed = String(data.timePlayed)
    }
}

struct DefaultStatisticsGameModesRepresentable: StatisticsGameModesRepresentable {
    var assists: String
    var boosts: String
    var dBNOS: String
    var dailyKills: String
    var dailyWINS: String
    var damageDealt: String
    var days: String
    var headshotKills: String
    var heals: String
    var kills: String
    var longestKill: String
    var losses: String
    var maxKillStreaks: String
    var timeSurvived: String
    var mostSurvivalTime: String
    var revives: String
    var rideDistance: String
    var roadKills: String
    var roundMostKills: String
    var roundsPlayed: String
    var suicides: String
    var swimDistance: String
    var teamKills: String
    var top10S: String
    var vehicleDestroys: String
    var walkDistance: String
    var weaponsAcquired: String
    var weeklyKills: String
    var weeklyWINS: String
    var wins: String
    
    init(_ data: DuoDTO) {
        assists = String(data.assists)
        boosts = String(data.boosts)
        dBNOS = String(data.dBNOS)
        dailyKills = String(data.dailyKills)
        dailyWINS = String(data.dailyWINS)
        damageDealt = String(data.damageDealt)
        days = String(data.days)
        headshotKills = String(data.headshotKills)
        heals = String(data.heals)
        kills = String(data.kills)
        longestKill = String(data.longestKill)
        losses = String(data.losses)
        maxKillStreaks = String(data.maxKillStreaks)
        timeSurvived = String(data.timeSurvived)
        mostSurvivalTime = String(data.mostSurvivalTime)
        revives = String(data.revives)
        rideDistance = String(data.rideDistance)
        roadKills = String(data.roadKills)
        roundMostKills = String(data.roundMostKills)
        roundsPlayed = String(data.roundsPlayed)
        suicides = String(data.suicides)
        swimDistance = String(data.swimDistance)
        teamKills = String(data.teamKills)
        top10S = String(data.top10S)
        vehicleDestroys = String(data.vehicleDestroys)
        walkDistance = String(data.walkDistance)
        weaponsAcquired = String(data.weaponsAcquired)
        weeklyKills = String(data.weeklyKills)
        weeklyWINS = String(data.weeklyWINS)
        wins = String(data.wins)
    }
}
