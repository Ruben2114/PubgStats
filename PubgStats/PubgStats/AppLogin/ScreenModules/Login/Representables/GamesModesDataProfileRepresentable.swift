//
//  GamesModesDataProfileRepresentable.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/10/23.
//

import Foundation

public protocol GamesModesDataProfileRepresentable {
    var bestRankPoint: Double? { get }
    var killsTotal: Int { get }
    var assistsTotal: Int { get }
    var gamesPlayed: Int { get }
    var wonTotal: Int { get }
    var top10STotal: Int { get }
    var headshotKillsTotal: Int { get }
    var timePlayed: String { get }
    var duo: StatisticsGameModesRepresentable { get }
    var duoFpp: StatisticsGameModesRepresentable { get }
    var solo: StatisticsGameModesRepresentable { get }
    var soloFpp: StatisticsGameModesRepresentable { get }
    var squad: StatisticsGameModesRepresentable { get }
    var squadFpp: StatisticsGameModesRepresentable { get }
}

public protocol StatisticsGameModesRepresentable {
    var assists: Int { get }
    var boosts: Int { get }
    var dBNOS: Int { get }
    var dailyKills: Int { get }
    var dailyWINS: Int { get }
    var damageDealt: Double { get }
    var days: Int { get }
    var headshotKills: Int { get }
    var heals: Int { get }
    var kills: Int { get }
    var longestKill: Double { get }
    var losses: Int { get }
    var maxKillStreaks: Int { get }
    var timeSurvived: Double { get }
    var mostSurvivalTime: Double { get }
    var revives: Int { get }
    var rideDistance: Double { get }
    var roadKills: Int { get }
    var roundMostKills: Int { get }
    var roundsPlayed: Int { get }
    var suicides: Int { get }
    var swimDistance: Double { get }
    var teamKills: Int { get }
    var top10S: Int { get }
    var vehicleDestroys: Int { get }
    var walkDistance: Double { get }
    var weaponsAcquired: Int { get }
    var weeklyKills: Int { get }
    var weeklyWINS: Int { get }
    var wins: Int { get }
}

struct DefaultGamesModesDataProfile: GamesModesDataProfileRepresentable {
    var bestRankPoint: Double?
    var killsTotal: Int
    var assistsTotal: Int
    var gamesPlayed: Int
    var wonTotal: Int
    var top10STotal: Int
    var headshotKillsTotal: Int
    var timePlayed: String
    var duo: StatisticsGameModesRepresentable
    var duoFpp: StatisticsGameModesRepresentable
    var solo: StatisticsGameModesRepresentable
    var soloFpp: StatisticsGameModesRepresentable
    var squad: StatisticsGameModesRepresentable
    var squadFpp: StatisticsGameModesRepresentable
    
    init(_ data: GamesModesDTO) {
        bestRankPoint = data.bestRank
        killsTotal = data.killsTotal
        assistsTotal = data.assistsTotal
        gamesPlayed = data.gamesPlayed
        wonTotal = data.wonTotal
        top10STotal = data.top10STotal
        headshotKillsTotal = data.headshotKillsTotal
        timePlayed = data.timePlayed
        duo = DefaultStatisticsGameModes(data.duo)
        duoFpp = DefaultStatisticsGameModes(data.duoFpp)
        solo = DefaultStatisticsGameModes(data.solo)
        soloFpp = DefaultStatisticsGameModes(data.soloFpp)
        squad = DefaultStatisticsGameModes(data.squad)
        squadFpp = DefaultStatisticsGameModes(data.squadFpp)
    }
    
    init(_ data: [GamesModes]) {
        solo = DefaultStatisticsGameModes(data.first(where: { gamesModes in gamesModes.mode == "solo"}))
        soloFpp = DefaultStatisticsGameModes(data.first(where: { gamesModes in gamesModes.mode == "soloFpp"}))
        duo = DefaultStatisticsGameModes(data.first(where: { gamesModes in gamesModes.mode == "duo"}))
        duoFpp = DefaultStatisticsGameModes(data.first(where: { gamesModes in gamesModes.mode == "duoFpp"}))
        squad = DefaultStatisticsGameModes(data.first(where: { gamesModes in gamesModes.mode == "squad"}))
        squadFpp = DefaultStatisticsGameModes(data.first(where: { gamesModes in gamesModes.mode == "squadFpp"}))
        bestRankPoint = data.first?.bestRankPoint
        killsTotal = Int(data.first?.killsTotal ?? 0)
        assistsTotal = Int(data.first?.assistsTotal ?? 0)
        gamesPlayed = Int(data.first?.gamesPlayed ?? 0)
        wonTotal = Int(data.first?.wonTotal ?? 0)
        top10STotal = Int(data.first?.top10STotal ?? 0)
        headshotKillsTotal = Int(data.first?.headshotKillsTotal ?? 0)
        timePlayed = data.first?.timePlayed ?? ""
    }
}

struct DefaultStatisticsGameModes: StatisticsGameModesRepresentable {
    var assists: Int
    var boosts: Int
    var dBNOS: Int
    var dailyKills: Int
    var dailyWINS: Int
    var damageDealt: Double
    var days: Int
    var headshotKills: Int
    var heals: Int
    var kills: Int
    var longestKill: Double
    var losses: Int
    var maxKillStreaks: Int
    var timeSurvived: Double
    var mostSurvivalTime: Double
    var revives: Int
    var rideDistance: Double
    var roadKills: Int
    var roundMostKills: Int
    var roundsPlayed: Int
    var suicides: Int
    var swimDistance: Double
    var teamKills: Int
    var top10S: Int
    var vehicleDestroys: Int
    var walkDistance: Double
    var weaponsAcquired: Int
    var weeklyKills: Int
    var weeklyWINS: Int
    var wins: Int
    
    init(_ data: DuoDTO) {
        assists = data.assists
        boosts = data.boosts
        dBNOS = data.dBNOS
        dailyKills = data.dailyKills
        dailyWINS = data.dailyWINS
        damageDealt = data.damageDealt
        days = data.days
        headshotKills = data.headshotKills
        heals = data.heals
        kills = data.kills
        longestKill = data.longestKill
        losses = data.losses
        maxKillStreaks = data.maxKillStreaks
        timeSurvived = data.timeSurvived
        mostSurvivalTime = data.mostSurvivalTime
        revives = data.revives
        rideDistance = data.rideDistance
        roadKills = data.roadKills
        roundMostKills = data.roundMostKills
        roundsPlayed = data.roundsPlayed
        suicides = data.suicides
        swimDistance = data.swimDistance
        teamKills = data.teamKills
        top10S = data.top10S
        vehicleDestroys = data.vehicleDestroys
        walkDistance = data.walkDistance
        weaponsAcquired = data.weaponsAcquired
        weeklyKills = data.weeklyKills
        weeklyWINS = data.weeklyWINS
        wins = data.wins
    }
    
    init(_ data: GamesModes?) {
        assists = Int(data?.assists ?? 0)
        boosts = Int(data?.boosts ?? 0)
        dBNOS = Int(data?.dBNOS ?? 0)
        dailyKills = Int(data?.dailyKills ?? 0)
        dailyWINS = Int(data?.dailyWINS ?? 0)
        damageDealt = data?.damageDealt ?? 0
        days = Int(data?.days ?? 0)
        headshotKills = Int(data?.headshotKills ?? 0)
        heals = Int(data?.heals ?? 0)
        kills = Int(data?.kills ?? 0)
        longestKill = data?.longestKill ?? 0
        losses = Int(data?.losses ?? 0)
        maxKillStreaks = Int(data?.maxKillStreaks ?? 0)
        timeSurvived = data?.timeSurvived ?? 0
        mostSurvivalTime = data?.mostSurvivalTime ?? 0
        revives = Int(data?.revives ?? 0)
        rideDistance = data?.rideDistance ?? 0
        roadKills = Int(data?.roadKills ?? 0)
        roundMostKills = Int(data?.roundMostKills ?? 0)
        roundsPlayed = Int(data?.roundsPlayed ?? 0)
        suicides = Int(data?.suicides ?? 0)
        swimDistance = data?.swimDistance ?? 0
        teamKills = Int(data?.teamKills ?? 0)
        top10S = Int(data?.top10S ?? 0)
        vehicleDestroys = Int(data?.vehicleDestroys ?? 0)
        walkDistance = data?.walkDistance ?? 0
        weaponsAcquired = Int(data?.weaponsAcquired ?? 0)
        weeklyKills = Int(data?.weeklyKills ?? 0)
        weeklyWINS = Int(data?.weeklyWINS ?? 0)
        wins = Int(data?.wins ?? 0)
    }
}
