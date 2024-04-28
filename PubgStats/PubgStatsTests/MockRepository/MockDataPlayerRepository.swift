//
//  MockDataProfleRepository.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 12/10/23.
//

import Foundation
import Combine
import PubgStats

struct MockDataPlayerRepository: DataPlayerRepository {
    func fetchPlayerData(name: String, platform: String, type: NavigationStats) -> AnyPublisher<IdAccountDataProfileRepresentable, Error> {
        if name.isEmpty || platform.isEmpty {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        } else {
            return Just(MockIdAccountDataProfile(id: "1111", name: name, platform: platform)).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
    }
    
    func fetchMatchesData(id: String, platform: String) -> AnyPublisher<MatchDataProfileRepresentable, Error> {
        return Just(MockMatchDataProfile()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func deletePlayerData(profile: IdAccountDataProfileRepresentable) -> AnyPublisher<Void, Error> {
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func fetchSurvivalData(representable: PubgStats.IdAccountDataProfileRepresentable, type: NavigationStats, reload: Bool) -> AnyPublisher<PubgStats.SurvivalDataProfileRepresentable, Error> {
        Just(MockSurvivalDataProfile()).setFailureType(to: Error.self).eraseToAnyPublisher()

    }
    
    func fetchGamesModeData(representable: PubgStats.IdAccountDataProfileRepresentable, type: NavigationStats, reload: Bool) -> AnyPublisher<PubgStats.GamesModesDataProfileRepresentable, Error> {
        Just(MockGamesModesDataProfile()).setFailureType(to: Error.self).eraseToAnyPublisher()

    }
    
    func fetchWeaponData(representable: PubgStats.IdAccountDataProfileRepresentable, type: NavigationStats, reload: Bool) -> AnyPublisher<PubgStats.WeaponDataProfileRepresentable, Error> {
        Just(MockWeaponDataProfile()).setFailureType(to: Error.self).eraseToAnyPublisher()
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
    var matches: [String]
    var bestRankPoint: Double?
    var killsTotal: Int
    var assistsTotal: Int
    var gamesPlayed: Int
    var wonTotal: Int
    var top10STotal: Int
    var headshotKillsTotal: Int
    var timePlayed: String
    var modes: [StatisticsGameModesRepresentable]
    
    init() {
        self.bestRankPoint = nil
        self.killsTotal = 0
        self.assistsTotal = 0
        self.gamesPlayed = 0
        self.wonTotal = 0
        self.top10STotal = 0
        self.headshotKillsTotal = 0
        self.timePlayed = "timePlayed"
        self.modes = []
        self.matches = []
    }
}

struct MockStatisticsGameModes: StatisticsGameModesRepresentable {
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
    
    init() {
        self.mode = "mode"
        self.assists = 0
        self.boosts = 0
        self.dBNOS = 0
        self.dailyKills = 0
        self.dailyWINS = 0
        self.damageDealt = 0
        self.days = 0
        self.headshotKills = 0
        self.heals = 0
        self.kills = 0
        self.longestKill = 0
        self.losses = 0
        self.maxKillStreaks = 0
        self.timeSurvived = 0
        self.mostSurvivalTime = 0
        self.revives = 0
        self.rideDistance = 0
        self.roadKills = 0
        self.roundMostKills = 0
        self.roundsPlayed = 0
        self.suicides = 0
        self.swimDistance = 0
        self.teamKills = 0
        self.top10S = 0
        self.vehicleDestroys = 0
        self.walkDistance = 0
        self.weaponsAcquired = 0
        self.weeklyKills = 0
        self.weeklyWINS = 0
        self.wins = 0
    }
}

struct MockWeaponDataProfile: WeaponDataProfileRepresentable {
    var weaponSummaries: [WeaponSummaryRepresentable]
    
    init() {
        self.weaponSummaries = []
    }
}

struct MockMatchDataProfile: MatchDataProfileRepresentable {
    var type: String
    var id: String
    var attributes: MatchAttributesRepresentable
    var included: [MatchIncludedRepresentable]
    var links: String
    
    init() {
        self.type = "rank"
        self.id = "1"
        self.attributes = MockMatchAttributes()
        self.included = []
        self.links = "links"
    }
}

struct MockMatchAttributes : MatchAttributesRepresentable {
    var mapName: String
    var isCustomMatch: Bool
    var matchType: String
    var duration: Int
    var gameMode: String
    var shardID: String
    var createdAt: String
    var titleID: String
    var seasonState: String
    
    init() {
        self.mapName = "mapName"
        self.isCustomMatch = false
        self.matchType = "matchType"
        self.duration = 0
        self.gameMode = "gameMode"
        self.shardID = "shardID"
        self.createdAt = "createdAt"
        self.titleID = "titleID"
        self.seasonState = "seasonState"
    }
}
