//
//  ApiClient.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 21/3/23.
//

import Foundation
import Combine

//https://documentation.pubg.com/en/getting-started.html
   // "<eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJqdGkiOiIzODNhYWY2MC05MzNmLTAxM2ItMDFmYy01NzVjNzBiMzFiMzkiLCJpc3MiOiJnYW1lbG9ja2VyIiwiaWF0IjoxNjc2ODkyMzM2LCJwdWIiOiJibHVlaG9sZSIsInRpdGxlIjoicHViZyIsImFwcCI6ImxleWVuZGEyMSJ9.OxjYiTYVbtFMNQt2gTwXskHksNex8IGsiCYN1RvGOQw>"

protocol APIManagerService {
    func dataPlayer<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void)
}

class PubgApi: APIManagerService {
    let apiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJqdGkiOiIzODNhYWY2MC05MzNmLTAxM2ItMDFmYy01NzVjNzBiMzFiMzkiLCJpc3MiOiJnYW1lbG9ja2VyIiwiaWF0IjoxNjc2ODkyMzM2LCJwdWIiOiJibHVlaG9sZSIsInRpdGxlIjoicHViZyIsImFwcCI6ImxleWVuZGEyMSJ9.OxjYiTYVbtFMNQt2gTwXskHksNex8IGsiCYN1RvGOQw"
    private var subscribers = Set<AnyCancellable>()
    
    func dataPlayer<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/vnd.api+json", forHTTPHeaderField: "accept")
        URLSession.shared.dataTaskPublisher(for: request)
            .map{ $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { (resultCompletion) in
                switch resultCompletion {
                case .failure(let error):
                    completion(.failure(error))
                case .finished: break
                }
            }, receiveValue: { (result) in
                completion(.success(result))
            }).store(in: &subscribers)
    }
}
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

