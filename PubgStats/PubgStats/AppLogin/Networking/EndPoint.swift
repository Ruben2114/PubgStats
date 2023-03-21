//
//  EndPoint.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 21/3/23.
//

enum ApisUrl {
    private var baseUrl: String { return "https://api.pubg.com/shards/steam/players"}
    case generalData(nombre: String)
    case survivalData(id: String)
    case weaponData(id: String)
    case gameModeData(id: String)
    var urlString: String {
        var endpoint: String
        switch self {
        case .generalData(let name): endpoint = "?filter[playerNames]=\(name)"
        case .survivalData(let id): endpoint = "/\(id)/survival_mastery"
        case .weaponData(let id): endpoint = "/\(id)/weapon_mastery"
        case .gameModeData(let id): endpoint = "/\(id)/seasons/lifetime?filter[gamepad]=false"
        }
        return baseUrl + endpoint
    }
}
