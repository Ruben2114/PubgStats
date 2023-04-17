//
//  SettingsDataUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 17/4/23.
//

protocol SettingsDataUseCase {
    func deleteProfile(sessionUser: ProfileEntity)
}

struct SettingsDataUseCaseImp: SettingsDataUseCase {
    private let settingsDataRepository: SettingsDataRepository
    init(dependencies: SettingsDependency){
        self.settingsDataRepository = dependencies.resolve()
    }
    func deleteProfile(sessionUser: ProfileEntity) {
        settingsDataRepository.deleteProfile(sessionUser: sessionUser)
    }
}
