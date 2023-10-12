//
//  DataProfleRepository.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 12/10/23.
//

import Foundation
import Combine

public protocol DataProfleRepository {
    func fetchPlayerData(name: String, platform: String) -> AnyPublisher<IdAccountDataProfile, Error>
}
