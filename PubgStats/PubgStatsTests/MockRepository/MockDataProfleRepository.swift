//
//  MockDataProfleRepository.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 12/10/23.
//

import Foundation
import Combine
import PubgStats

struct MockDataProfleRepository: DataProfleRepository {
    
    func fetchPlayerData(name: String, platform: String) -> AnyPublisher<IdAccountDataProfileRepresentable, Error> {
        return Just(MockIdAccountDataProfile(id: "", name: "")).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}

//MARK: - Mock Representables
struct MockIdAccountDataProfile: IdAccountDataProfileRepresentable {
    var id: String?
    var name: String?
    
    init(id: String? = nil, name: String? = nil) {
        self.id = id
        self.name = name
    }
}
