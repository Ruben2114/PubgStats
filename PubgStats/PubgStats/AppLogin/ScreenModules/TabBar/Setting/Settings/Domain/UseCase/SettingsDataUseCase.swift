//
//  SettingsDataUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 17/4/23.
//

protocol SettingsDataUseCase {
    func deleteProfile()
}

struct SettingsDataUseCaseImp: SettingsDataUseCase {
    private let settingsDataRepository: SettingsDataRepository
    init(dependencies: SettingsDependency){
        self.settingsDataRepository = dependencies.resolve()
    }
    func deleteProfile() {
        settingsDataRepository.deleteProfile()
    }
}
