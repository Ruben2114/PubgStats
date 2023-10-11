//
//  ProfileDataUseCase.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 21/3/23.
//

import Foundation
import Combine

protocol ProfileDataUseCase: CommonUseCase {
    func fetchPlayerData(name: String, platform: String) -> AnyPublisher<PubgPlayerDTO, Error>
}

struct ProfileDataUseCaseImp: ProfileDataUseCase{
    internal let commonRepository: CommonRepository
    private let profileRepository: ProfileRepository
    init(dependencies: ProfileDependency) {
        self.commonRepository = dependencies.external.resolve()
        self.profileRepository = dependencies.resolve()
    }
    
    func fetchPlayerData(name: String, platform: String) -> AnyPublisher<PubgPlayerDTO, Error> {
        profileRepository.fetchPlayerData(name: name, platform: platform).eraseToAnyPublisher()
    }
}
