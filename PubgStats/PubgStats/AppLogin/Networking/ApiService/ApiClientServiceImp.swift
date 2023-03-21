//
//  ApiClientServiceImp.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 21/3/23.
//

import Foundation
import Combine

//https://documentation.pubg.com/en/getting-started.html
   // "<eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJqdGkiOiIzODNhYWY2MC05MzNmLTAxM2ItMDFmYy01NzVjNzBiMzFiMzkiLCJpc3MiOiJnYW1lbG9ja2VyIiwiaWF0IjoxNjc2ODkyMzM2LCJwdWIiOiJibHVlaG9sZSIsInRpdGxlIjoicHViZyIsImFwcCI6ImxleWVuZGEyMSJ9.OxjYiTYVbtFMNQt2gTwXskHksNex8IGsiCYN1RvGOQw>"

class ApiClientServiceImp: ApiClientService {
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

