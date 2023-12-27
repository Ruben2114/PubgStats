//
//  MockDataProfleRepository.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 12/10/23.
//

import Foundation
import Combine
import PubgStats

struct MockDataProfleRepository: DataProfileRepository {
    func fetchSurvivalData(name: String, account: String, platform: String) -> AnyPublisher<SurvivalDataProfileRepresentable, Error> {
        Just(MockSurvivalDataProfile()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func fetchGamesModeData(name: String, account: String, platform: String) -> AnyPublisher<GamesModesDataProfileRepresentable, Error> {
        Just(MockGamesModesDataProfile()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func fetchWeaponData(name: String, account: String, platform: String) -> AnyPublisher<WeaponDataProfileRepresentable, Error> {
        Just(MockWeaponDataProfile()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func fetchPlayerData(name: String, platform: String) -> AnyPublisher<IdAccountDataProfileRepresentable, Error> {
        return Just(MockIdAccountDataProfile(id: "1111", name: name, platform: platform)).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}

//MARK: - Mock Representables
struct MockIdAccountDataProfile: IdAccountDataProfileRepresentable {
    var id: String
    var name: String
    var platform: String
    
    init(id: String, name: String, platform: String) {
        self.id = id
        self.name = name
        self.platform = platform
    }
}


struct MockSurvivalDataProfile: SurvivalDataProfileRepresentable {
    var totalMatchesPlayed: String
    var stats: StatSurvival
    var xp: String
    var level: String
    
    init() {
        self.totalMatchesPlayed = "1000"
        self.stats = MockStatSurvival()
        self.xp = "10"
        self.level = "1"
    }
}

struct MockStatSurvival: StatSurvival {
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
    
    init(airDropsCalled: String? = nil, damageDealt: String? = nil, damageTaken: String? = nil, distanceBySwimming: String? = nil, distanceByVehicle: String? = nil, distanceOnFoot: String? = nil, distanceTotal: String? = nil, healed: String? = nil, hotDropLandings: String? = nil, enemyCratesLooted: String? = nil, uniqueItemsLooted: String? = nil, position: String? = nil, revived: String? = nil, teammatesRevived: String? = nil, timeSurvived: String? = nil, throwablesThrown: String? = nil, top10: String? = nil) {
        self.airDropsCalled = airDropsCalled
        self.damageDealt = damageDealt
        self.damageTaken = damageTaken
        self.distanceBySwimming = distanceBySwimming
        self.distanceByVehicle = distanceByVehicle
        self.distanceOnFoot = distanceOnFoot
        self.distanceTotal = distanceTotal
        self.healed = healed
        self.hotDropLandings = hotDropLandings
        self.enemyCratesLooted = enemyCratesLooted
        self.uniqueItemsLooted = uniqueItemsLooted
        self.position = position
        self.revived = revived
        self.teammatesRevived = teammatesRevived
        self.timeSurvived = timeSurvived
        self.throwablesThrown = throwablesThrown
        self.top10 = top10
    }
}

struct MockGamesModesDataProfile: GamesModesDataProfileRepresentable {
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
    
    init() {
        self.bestRankPoint = nil
        self.killsTotal = 1
        self.assistsTotal = 2
        self.gamesPlayed = 3
        self.wonTotal = 4
        self.top10STotal = 5
        self.headshotKillsTotal = 6
        self.timePlayed = "7d"
        self.duo = MockStatisticsGameModes()
        self.duoFpp = MockStatisticsGameModes()
        self.solo = MockStatisticsGameModes()
        self.soloFpp = MockStatisticsGameModes()
        self.squad = MockStatisticsGameModes()
        self.squadFpp = MockStatisticsGameModes()
    }
}

struct MockStatisticsGameModes: StatisticsGameModesRepresentable {
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
    
    init() {
        self.assists = "assists"
        self.boosts = "boosts"
        self.dBNOS = "dBNOS"
        self.dailyKills = "dailyKills"
        self.dailyWINS = "dailyWINS"
        self.damageDealt = "damageDealt"
        self.days = "days"
        self.headshotKills = "headshotKills"
        self.heals = "heals"
        self.kills = "kills"
        self.longestKill = "longestKill"
        self.losses = "losses"
        self.maxKillStreaks = "maxKillStreaks"
        self.timeSurvived = "timeSurvived"
        self.mostSurvivalTime = "mostSurvivalTime"
        self.revives = "revives"
        self.rideDistance = "rideDistance"
        self.roadKills = "roadKills"
        self.roundMostKills = "roundMostKills"
        self.roundsPlayed = "roundsPlayed"
        self.suicides = "suicides"
        self.swimDistance = "swimDistance"
        self.teamKills = "teamKills"
        self.top10S = "top10S"
        self.vehicleDestroys = "vehicleDestroys"
        self.walkDistance = "walkDistance"
        self.weaponsAcquired = "weaponsAcquired"
        self.weeklyKills = "weeklyKills"
        self.weeklyWINS = "weeklyWINS"
        self.wins = "wins"
    }
}

struct MockWeaponDataProfile: WeaponDataProfileRepresentable {
    var weaponSummaries: [WeaponSummaryRepresentable]
    
    init() {
        self.weaponSummaries = []
    }
}
