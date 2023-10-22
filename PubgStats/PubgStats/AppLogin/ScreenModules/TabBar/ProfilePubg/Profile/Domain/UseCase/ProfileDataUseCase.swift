//
//  ProfileDataUseCase.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 21/3/23.
//

import Foundation
import Combine

protocol ProfileDataUseCase {
    func fetchGamesModeData(name: String, account: String, platform: String) -> AnyPublisher<GamesModesDataProfileRepresentable, Error>
}

struct ProfileDataUseCaseImp: ProfileDataUseCase{
    private let profileRepository: DataProfleRepository
    init(dependencies: ProfileDependency) {
        self.profileRepository = dependencies.external.resolve()
    }
    
    func fetchGamesModeData(name: String, account: String, platform: String) -> AnyPublisher<GamesModesDataProfileRepresentable, Error>  {
        profileRepository.fetchGamesModeData(name: name, account: account, platform: platform).eraseToAnyPublisher()
    }
}
