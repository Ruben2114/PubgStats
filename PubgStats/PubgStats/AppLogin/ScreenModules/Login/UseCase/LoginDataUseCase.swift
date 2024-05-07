//
//  LoginDataUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 14/3/23.
//

import Combine

public protocol LoginDataUseCase {
    func fetchPlayerData(name: String, platform: String) -> AnyPublisher<IdAccountDataProfileRepresentable, Error>
}

struct LoginDataUseCaseImp: LoginDataUseCase {
    private let profileRepository: DataPlayerRepository
    init(dependencies: LoginDependencies) {
        self.profileRepository = dependencies.external.resolve()
    }
    
    func fetchPlayerData(name: String, platform: String) -> AnyPublisher<IdAccountDataProfileRepresentable, Error> {
        profileRepository.fetchPlayerData(name: name, platform: platform, type: .profile).eraseToAnyPublisher()
    }
}
