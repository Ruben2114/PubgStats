//
//  Player.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

import Foundation
struct PubgPlayer {
    private let data: [PubgPlayerData]
    var name: String? {
        data.first?.attributes.name
    }
    var id: String? {
        data.first?.id
    }
}
// MARK: - PubgPlayerData
struct PubgPlayerData {
    let type, id: String
    let attributes: PubgPlayerAttributes
}
// MARK: - PubgPlayerAttributes
struct PubgPlayerAttributes {
    let name, titleID, shardID: String
    enum CodingKeys: String, CodingKey {
        case name
        case titleID = "titleId"
        case shardID = "shardId"
    }
}
