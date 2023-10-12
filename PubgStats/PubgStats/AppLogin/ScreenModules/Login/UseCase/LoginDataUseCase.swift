//
//  LoginDataUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 14/3/23.
//

import Combine

protocol LoginDataUseCase {
    func fetchPlayerData(name: String, platform: String) -> AnyPublisher<IdAccountDataProfile, Error>
}

struct LoginDataUseCaseImp: LoginDataUseCase {
    private let profileRepository: DataProfleRepository
    init(dependencies: LoginDependency) {
        self.profileRepository = dependencies.external.resolve()
    }
    
    func fetchPlayerData(name: String, platform: String) -> AnyPublisher<IdAccountDataProfile, Error> {
        profileRepository.fetchPlayerData(name: name, platform: platform).eraseToAnyPublisher()
    }
}
