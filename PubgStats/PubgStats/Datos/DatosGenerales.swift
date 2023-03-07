//
//  DatosGenerales.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 7/3/23.
//

import Foundation
struct PubgJugador: Decodable {
    private let data: [DatosPubgJugador]
    var name: String? {
        data.first?.attributes.name
    }
    var id: String? {
        data.first?.id
    }
}
struct DatosPubgJugador: Decodable {
    let type, id: String
    let attributes: AtributosPubgJugador
}
struct AtributosPubgJugador: Decodable {
    let name, titleID, shardID: String
    enum CodingKeys: String, CodingKey {
        case name
        case titleID = "titleId"
        case shardID = "shardId"
    }
}
