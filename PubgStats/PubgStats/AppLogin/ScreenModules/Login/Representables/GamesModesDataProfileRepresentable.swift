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
    var modes: [StatisticsGameModesRepresentable] { get }
    var matches: [String] { get }
}

public protocol StatisticsGameModesRepresentable {
    var mode: String { get }
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
    var modes: [StatisticsGameModesRepresentable]
    var matches: [String]
    
    init(_ data: GamesModesDTO) {
        bestRankPoint = data.bestRank
        killsTotal = data.killsTotal
        assistsTotal = data.assistsTotal
        gamesPlayed = data.gamesPlayed
        wonTotal = data.wonTotal
        top10STotal = data.top10STotal
        headshotKillsTotal = data.headshotKillsTotal
        timePlayed = data.timePlayed
        modes = data.modes.map { DefaultStatisticsGameModes($0.value, title: $0.key) }
        matches = data.matches.flatMap { $0.data.map { $0.id} }
    }
    
    init(_ data: [GamesModes]) {
        bestRankPoint = data.first?.bestRankPoint
        killsTotal = Int(data.first?.killsTotal ?? 0)
        assistsTotal = Int(data.first?.assistsTotal ?? 0)
        gamesPlayed = Int(data.first?.gamesPlayed ?? 0)
        wonTotal = Int(data.first?.wonTotal ?? 0)
        top10STotal = Int(data.first?.top10STotal ?? 0)
        headshotKillsTotal = Int(data.first?.headshotKillsTotal ?? 0)
        timePlayed = data.first?.timePlayed ?? ""
        modes = data.map{DefaultStatisticsGameModes($0, title: $0.mode ?? "")}
        guard let modeData = data.first?.matches, let dataWeapon = try? PropertyListSerialization.propertyList(from: modeData, options: [],format: nil) as? [String] else {
            matches = []
            return
        }
        matches = dataWeapon
    }
}

struct DefaultStatisticsGameModes: StatisticsGameModesRepresentable {
    var mode: String
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
    
    init(_ data: DuoDTO, title: String) {
        mode = title
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
    
    init(_ data: GamesModes, title: String) {
        mode = title
        assists = Int(data.assists)
        boosts = Int(data.boosts)
        dBNOS = Int(data.dBNOS)
        dailyKills = Int(data.dailyKills)
        dailyWINS = Int(data.dailyWINS)
        damageDealt = data.damageDealt
        days = Int(data.days)
        headshotKills = Int(data.headshotKills)
        heals = Int(data.heals)
        kills = Int(data.kills)
        longestKill = data.longestKill
        losses = Int(data.losses)
        maxKillStreaks = Int(data.maxKillStreaks)
        timeSurvived = data.timeSurvived
        mostSurvivalTime = data.mostSurvivalTime
        revives = Int(data.revives)
        rideDistance = data.rideDistance
        roadKills = Int(data.roadKills)
        roundMostKills = Int(data.roundMostKills)
        roundsPlayed = Int(data.roundsPlayed)
        suicides = Int(data.suicides)
        swimDistance = data.swimDistance
        teamKills = Int(data.teamKills)
        top10S = Int(data.top10S)
        vehicleDestroys = Int(data.vehicleDestroys)
        walkDistance = data.walkDistance
        weaponsAcquired = Int(data.weaponsAcquired)
        weeklyKills = Int(data.weeklyKills)
        weeklyWINS = Int(data.weeklyWINS)
        wins = Int(data.wins)
    }
}
