//
//  ProfileRepository.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 21/3/23.
//

import Foundation
import Combine

protocol ProfileRepository {
    func fetchPlayerData(name: String, platform: String) -> AnyPublisher<PubgPlayerDTO, Error>
}

