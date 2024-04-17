//
//  MatchDataProfileRepresentable.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 8/4/24.
//

import Foundation

public protocol MatchDataProfileRepresentable {
    var type : String { get }
    var id: String { get }
    var attributes: MatchAttributesRepresentable { get }
    var included: [MatchIncludedRepresentable] { get }
    var links: String { get }
}

public protocol MatchAttributesRepresentable {
    var mapName: String { get }
    var isCustomMatch: Bool { get }
    var matchType: String { get }
    var duration: Int { get }
    var gameMode: String { get }
    var shardID: String { get }
    var createdAt: String { get }
    var titleID: String { get }
    var seasonState: String { get }
}

public protocol MatchIncludedRepresentable {
    var type: String { get }
    var id: String { get }
    var attributes: MatchIncludedAttributesRepresentable { get }
    var team: [MatchRelationshipsDetailsDataRepresentable]? { get }
    var participants: [MatchRelationshipsDetailsDataRepresentable]? { get }
}

public protocol MatchIncludedAttributesRepresentable {
    var stats: MatchStatsRepresentable? { get }
    var actor: String? { get }
    var shardID: String? { get }
    var won: String? { get }
    var description: String? { get }
    var createdAt: String? { get }
    var url: String? { get }
    var name: String? { get }
}

public protocol MatchStatsRepresentable {
    var boosts: Int? { get }
    var DBNOs: Int? { get }
    var assists: Int? { get }
    var damageDealt: Double? { get }
    var deathType: String? { get }
    var headshotKills: Int? { get }
    var heals: Int? { get }
    var killPlace: Int? { get }
    var killStreaks: Int? { get }
    var kills: Int? { get }
    var longestKill: Double? { get }
    var name: String? { get }
    var playerID: String? { get }
    var revives: Int? { get }
    var rideDistance: Double? { get }
    var roadKills: Int? { get }
    var swimDistance: Double? { get }
    var teamKills: Int? { get }
    var timeSurvived: Int? { get }
    var vehicleDestroys: Int? { get }
    var walkDistance: Double? { get }
    var weaponsAcquired: Int? { get }
    var winPlace: Int? { get }
    var rank: Int? { get }
    var teamID: Int? { get }
}

public protocol MatchRelationshipsDetailsDataRepresentable {
    var type: String { get }
    var id: String { get }
}

// MARK: - Implementation
struct DefaultMatchDataProfile: MatchDataProfileRepresentable {
    var type: String
    var id: String
    var attributes: MatchAttributesRepresentable
    var included: [MatchIncludedRepresentable]
    var links: String
    
    
    init(_ match: MatchDTO) {
        self.type = match.data.type
        self.id = match.data.id
        self.attributes = DefaultMatchAttributes(match.data.attributes)
        self.included = match.included.map { DefaultMatchIncluded($0) }
        self.links = match.links.linksSelf
    }
}

struct DefaultMatchAttributes: MatchAttributesRepresentable {
    var mapName: String
    var isCustomMatch: Bool
    var matchType: String
    var duration: Int
    var gameMode: String
    var shardID: String
    var createdAt: String
    var titleID: String
    var seasonState: String
    
    init(_ attributes: MatchAttributes) {
        self.mapName = attributes.mapName
        self.isCustomMatch = attributes.isCustomMatch
        self.matchType = attributes.matchType
        self.duration = attributes.duration
        self.gameMode = attributes.gameMode
        self.shardID = attributes.shardID
        self.createdAt = attributes.createdAt
        self.titleID = attributes.titleID
        self.seasonState = attributes.seasonState
    }
}

struct DefaultMatchIncluded: MatchIncludedRepresentable {
    var type: String
    var id: String
    var attributes: MatchIncludedAttributesRepresentable
    var team: [MatchRelationshipsDetailsDataRepresentable]?
    var participants: [MatchRelationshipsDetailsDataRepresentable]?
    
    init(_ included: MatchIncluded) {
        self.type = included.type
        self.id = included.id
        self.attributes = DefaultMatchIncludedAttributes(included.attributes)
        self.team = included.relationships?.team.data?.map { DefaultMatchRelationshipsDetailsData($0) }
        self.participants = included.relationships?.participants.data?.map { DefaultMatchRelationshipsDetailsData($0) }
    }
}

struct DefaultMatchIncludedAttributes: MatchIncludedAttributesRepresentable {
    var stats: MatchStatsRepresentable?
    var actor: String?
    var shardID: String?
    var won: String?
    var description: String?
    var createdAt: String?
    var url: String?
    var name: String?
    
    init(_ includedAttributes: MatchIncludedAttributes) {
        self.stats = DefaultMatchStats(includedAttributes.stats)
        self.actor = includedAttributes.actor
        self.shardID = includedAttributes.shardID
        self.won = includedAttributes.won
        self.description = includedAttributes.description
        self.createdAt = includedAttributes.createdAt
        self.url = includedAttributes.url
        self.name = includedAttributes.name
    }
}

struct DefaultMatchStats: MatchStatsRepresentable {
    var boosts: Int?
    var DBNOs: Int?
    var assists: Int?
    var damageDealt: Double?
    var deathType: String?
    var headshotKills: Int?
    var heals: Int?
    var killPlace: Int?
    var killStreaks: Int?
    var kills: Int?
    var longestKill: Double?
    var name: String?
    var playerID: String?
    var revives: Int?
    var rideDistance: Double?
    var roadKills: Int?
    var swimDistance: Double?
    var teamKills: Int?
    var timeSurvived: Int?
    var vehicleDestroys: Int?
    var walkDistance: Double?
    var weaponsAcquired: Int?
    var winPlace: Int?
    var rank: Int?
    var teamID: Int?
    
    init(_ stats: MatchStats?) {
        self.boosts = stats?.boosts
        self.DBNOs = stats?.DBNOs
        self.assists = stats?.assists
        self.damageDealt = stats?.damageDealt
        self.deathType = stats?.deathType?.rawValue
        self.headshotKills = stats?.headshotKills
        self.heals = stats?.heals
        self.killPlace = stats?.killPlace
        self.killStreaks = stats?.killStreaks
        self.kills = stats?.kills
        self.longestKill = stats?.longestKill
        self.name = stats?.name
        self.playerID = stats?.playerID
        self.revives = stats?.revives
        self.rideDistance = stats?.rideDistance
        self.roadKills = stats?.roadKills
        self.swimDistance = stats?.swimDistance
        self.teamKills = stats?.teamKills
        self.timeSurvived = stats?.timeSurvived
        self.vehicleDestroys = stats?.vehicleDestroys
        self.walkDistance = stats?.walkDistance
        self.weaponsAcquired = stats?.weaponsAcquired
        self.winPlace = stats?.winPlace
        self.rank = stats?.rank
        self.teamID = stats?.teamID
    }
}

struct DefaultMatchRelationshipsDetailsData: MatchRelationshipsDetailsDataRepresentable {
    var type: String
    var id: String
    
    init(_ data: MatchRelationshipsDetailsData ) {
        self.type = data.type
        self.id = data.id
    }
}
