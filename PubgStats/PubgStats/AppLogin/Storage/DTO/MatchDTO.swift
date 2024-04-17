//
//  MatchDTO.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 8/4/24.
//

// MARK: - MatchDTO
struct MatchDTO: Decodable {
    let data: MatchData
    let included: [MatchIncluded]
    let links: MatchLinks
}

// MARK: - MatchData
struct MatchData: Decodable {
    let type, id: String
    let attributes: MatchAttributes
    let relationships: MatchRelationships
}

// MARK: - DataAttributes
struct MatchAttributes: Decodable {
    let mapName: String
    let isCustomMatch: Bool
    let matchType: String
    let duration: Int
    let gameMode: String
    let shardID: String
    let createdAt: String
    let titleID, seasonState: String

    enum CodingKeys: String, CodingKey {
        case mapName, isCustomMatch, matchType, duration, gameMode
        case shardID = "shardId"
        case createdAt
        case titleID = "titleId"
        case seasonState
    }
}

// MARK: - MatchRelationships
struct MatchRelationships: Decodable {
    let assets, rosters: MatchRelationshipsDetails
}

// MARK: - MatchRelationshipsDetails
struct MatchRelationshipsDetails: Decodable {
    let data: [MatchRelationshipsDetailsData]?
}

// MARK: - MatchRelationshipsDetailsData
struct MatchRelationshipsDetailsData: Decodable {
    let type: String
    let id: String
}

// MARK: - MatchIncluded
struct MatchIncluded: Decodable {
    let type: String
    let id: String
    let attributes: MatchIncludedAttributes
    let relationships: MatchIncludedRelationships?
}

// MARK: - MatchIncludedAttributes
struct MatchIncludedAttributes: Decodable {
    let stats: MatchStats?
    let actor: String?
    let shardID: String?
    let won, description: String?
    let createdAt: String?
    let url: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case stats, actor
        case shardID = "shardId"
        case won, description, createdAt
        case url = "URL"
        case name
    }
}

// MARK: - MatchStats
struct MatchStats: Decodable {
    let DBNOs, assists, boosts: Int?
    let damageDealt: Double?
    let deathType: MatchDeathType?
    let headshotKills, heals, killPlace, killStreaks: Int?
    let kills: Int?
    let longestKill: Double?
    let name, playerID: String?
    let revives: Int?
    let rideDistance: Double?
    let roadKills: Int?
    let swimDistance: Double?
    let teamKills, timeSurvived, vehicleDestroys: Int?
    let walkDistance: Double?
    let weaponsAcquired, winPlace, rank, teamID: Int?

    enum CodingKeys: String, CodingKey {
        case assists, boosts, damageDealt, deathType, headshotKills, heals, killPlace, killStreaks, kills, longestKill, name, DBNOs
        case playerID = "playerId"
        case revives, rideDistance, roadKills, swimDistance, teamKills, timeSurvived, vehicleDestroys, walkDistance, weaponsAcquired, winPlace, rank
        case teamID = "teamId"
    }
}

enum MatchDeathType: String, Decodable {
    case alive = "alive"
    case byplayer = "byplayer"
    case byzone = "byzone"
    case suicide = "suicide"
    case logout = "logout"
}

// MARK: - MatchIncludedRelationships
struct MatchIncludedRelationships: Decodable {
    let team, participants: MatchRelationshipsDetails
}

// MARK: - MatchLinks
struct MatchLinks: Decodable {
    let linksSelf: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}
