//
//  SettingsDataUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 17/4/23.
//

import Combine

public protocol SettingsDataUseCase {
    func deleteProfile(profile: IdAccountDataProfileRepresentable) -> AnyPublisher<Void, Error>
}

struct SettingsDataUseCaseImp: SettingsDataUseCase {
    private let settingsDataRepository: DataPlayerRepository
    
    init(dependencies: SettingsDependencies){
        self.settingsDataRepository = dependencies.external.resolve()
    }
}

extension SettingsDataUseCaseImp {
    func deleteProfile(profile: IdAccountDataProfileRepresentable) -> AnyPublisher<Void, Error> {
        settingsDataRepository.deletePlayerData(profile: profile).eraseToAnyPublisher()
    }
}
