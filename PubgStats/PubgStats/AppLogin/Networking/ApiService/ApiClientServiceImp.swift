//
//  ApiClientServiceImp.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 21/3/23.
//

import Foundation
import Combine
 //account.a4ef7b3e986f42baa12a7583cdea40fb
//division.bro.official.console-21

//https://api.pubg.com/shards/psn-eu/leaderboards/division.bro.official.console-22/squad
//TODO: para ver el ranking
class ApiClientServiceImp: ApiClientService {
    let apiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJqdGkiOiIzODNhYWY2MC05MzNmLTAxM2ItMDFmYy01NzVjNzBiMzFiMzkiLCJpc3MiOiJnYW1lbG9ja2VyIiwiaWF0IjoxNjc2ODkyMzM2LCJwdWIiOiJibHVlaG9sZSIsInRpdGxlIjoicHViZyIsImFwcCI6ImxleWVuZGEyMSJ9.OxjYiTYVbtFMNQt2gTwXskHksNex8IGsiCYN1RvGOQw"
    private var subscribers = Set<AnyCancellable>()
    
    func dataPlayer<T: Decodable>(url: URL) -> AnyPublisher<T, Error> {
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/vnd.api+json", forHTTPHeaderField: "accept")
        let publisher: AnyPublisher<T, Error> = URLSession.shared.dataTaskPublisher(for: request)
            .map{ $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        return publisher
    }
}

