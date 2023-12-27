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
    
    init(_ data: GamesModes?) {
        assists = data?.assists.description ?? ""
        boosts = data?.boosts.description ?? ""
        dBNOS = data?.dBNOS.description ?? ""
        dailyKills = data?.dailyKills.description ?? ""
        dailyWINS = data?.dailyWINS.description ?? ""
        damageDealt = data?.damageDealt.description ?? ""
        days = data?.days.description ?? ""
        headshotKills = data?.headshotKills.description ?? ""
        heals = data?.heals.description ?? ""
        kills = data?.kills.description ?? ""
        longestKill = data?.longestKill.description ?? ""
        losses = data?.losses.description ?? ""
        maxKillStreaks = data?.maxKillStreaks.description ?? ""
        timeSurvived = data?.timeSurvived.description ?? ""
        mostSurvivalTime = data?.mostSurvivalTime.description ?? ""
        revives = data?.revives.description ?? ""
        rideDistance = data?.rideDistance.description ?? ""
        roadKills = data?.roadKills.description ?? ""
        roundMostKills = data?.roundMostKills.description ?? ""
        roundsPlayed = data?.roundsPlayed.description ?? ""
        suicides = data?.suicides.description ?? ""
        swimDistance = data?.swimDistance.description ?? ""
        teamKills = data?.teamKills.description ?? ""
        top10S = data?.top10S.description ?? ""
        vehicleDestroys = data?.vehicleDestroys.description ?? ""
        walkDistance = data?.walkDistance.description ?? ""
        weaponsAcquired = data?.weaponsAcquired.description ?? ""
        weeklyKills = data?.weeklyKills.description ?? ""
        weeklyWINS = data?.weeklyWINS.description ?? ""
        wins = data?.wins.description ?? ""
    }
}
