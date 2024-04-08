//
//  ApiClientServiceImp.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 21/3/23.
//

import Foundation
import Combine

 //account.a4ef7b3e986f42baa12a7583cdea40fb
// usuario bueno: Aitzy, con id: account.3ea9a94f658446008f034ef343a4d619

class ApiClientServiceImp: ApiClientService {
    private let privateKey = "PUBG_PRIVATE_API_KEY"
    
    func dataPlayer<T: Decodable>(url: URL) -> AnyPublisher<T, Error> {
        var request = URLRequest(url: url)
        let environment = ProcessInfo.processInfo.environment[privateKey]
        request.setValue(environment, forHTTPHeaderField: "Authorization")
        request.setValue("application/vnd.api+json", forHTTPHeaderField: "accept")
        let publisher: AnyPublisher<T, Error> = URLSession.shared.dataTaskPublisher(for: request)
            .map{ $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        return publisher
    }
}
