//
//  PlayerDTO.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 21/3/23.
//

import Foundation
struct PubgPlayerDTO: Decodable {
    private let data: [PubgPlayerDataDTO]
    var name: String? {
        data.first?.attributes.name
    }
    var id: String? {
        data.first?.id
    }
}
// MARK: - PubgPlayerData
struct PubgPlayerDataDTO: Decodable {
    let type, id: String
    let attributes: PubgPlayerAttributesDTO
}
// MARK: - PubgPlayerAttributes
struct PubgPlayerAttributesDTO: Decodable {
    let name, titleID, shardID: String
    enum CodingKeys: String, CodingKey {
        case name
        case titleID = "titleId"
        case shardID = "shardId"
    }
}
