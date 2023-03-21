//
//  PlayerModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 21/3/23.
//

import Foundation
struct PubgPlayer: Decodable {
    private let data: [PubgPlayerData]
    var name: String? {
        data.first?.attributes.name
    }
    var id: String? {
        data.first?.id
    }
}
// MARK: - PubgPlayerData
struct PubgPlayerData: Decodable {
    let type, id: String
    let attributes: PubgPlayerAttributes
}
// MARK: - PubgPlayerAttributes
struct PubgPlayerAttributes: Decodable {
    let name, titleID, shardID: String
    enum CodingKeys: String, CodingKey {
        case name
        case titleID = "titleId"
        case shardID = "shardId"
    }
}
