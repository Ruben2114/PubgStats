//
//  ProfileDataUseCase.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 21/3/23.
//

import Foundation
import Combine

protocol ProfileDataUseCase {
    func fetchPlayerDetails(_ profile: IdAccountDataProfileRepresentable) -> AnyPublisher<PlayerDetailsRepresentable, Error>
}

struct ProfileDataUseCaseImp {
    private let profileRepository: DataProfileRepository
    
    init(dependencies: ProfileDependencies) {
        self.profileRepository = dependencies.external.resolve()
    }
}

extension ProfileDataUseCaseImp: ProfileDataUseCase {
    func fetchPlayerDetails(_ profile: IdAccountDataProfileRepresentable) -> AnyPublisher<PlayerDetailsRepresentable, Error> {
        return Publishers.CombineLatest3(profileRepository.fetchSurvivalData(representable: profile).eraseToAnyPublisher(),
                                         profileRepository.fetchGamesModeData(representable: profile).eraseToAnyPublisher(),
                                         profileRepository.fetchWeaponData(representable: profile).eraseToAnyPublisher())
        .map { (SurvivalDataProfileRepresentable, GamesModesDataProfileRepresentable, WeaponDataProfileRepresentable) in
            DefaultPlayerDetails(infoSurvival: SurvivalDataProfileRepresentable,
                                 infoGamesModes: GamesModesDataProfileRepresentable,
                                 infoWeapon: WeaponDataProfileRepresentable)
        }.eraseToAnyPublisher()
    }
}

protocol PlayerDetailsRepresentable {
    var infoSurvival: SurvivalDataProfileRepresentable { get }
    var infoGamesModes: GamesModesDataProfileRepresentable { get }
    var infoWeapon: WeaponDataProfileRepresentable { get }
}

struct DefaultPlayerDetails: PlayerDetailsRepresentable {
    var infoSurvival: SurvivalDataProfileRepresentable
    var infoGamesModes: GamesModesDataProfileRepresentable
    var infoWeapon: WeaponDataProfileRepresentable
}
