//
//  EndPoint.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 21/3/23.
//

enum ApisUrl {
    //TODO: cambiar steam por un enum que pueda ser steam o xbox lo elija en el textfield, y se guarde en core data para las llamadas
    //llamadas tanto en profile como en favourite, en favourite dentro
    //searchbar un boton que seleccione steam o xbox y que este predefinido steam
    private var baseUrl: String { return "https://api.pubg.com/shards"}
    case generalData(name: String, platform: String)
    case survivalData(id: String, platform: String)
    case weaponData(id: String, platform: String)
    case gameModeData(id: String, platform: String)
    var urlString: String {
        var endpoint: String
        switch self {
        case .generalData(let name, let platform): endpoint = "/\(platform)/players?filter[playerNames]=\(name)"
        case .survivalData(let id, let platform): endpoint = "/\(platform)/players/\(id)/survival_mastery"
        case .weaponData(let id, let platform): endpoint = "/\(platform)/players/\(id)/weapon_mastery"
        case .gameModeData(let id, let platform): endpoint = "/\(platform)/players/\(id)/seasons/lifetime?filter[gamepad]=false"
        }
        return baseUrl + endpoint
    }
}
