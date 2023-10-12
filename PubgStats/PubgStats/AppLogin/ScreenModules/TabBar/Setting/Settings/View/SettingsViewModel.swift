//
//  SettingsViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 17/4/23.
//

import Foundation

final class SettingsViewModel {
    private weak var coordinator: SettingsCoordinator?
    private let dependencies: SettingsDependency
    private let settingsDataUseCase: SettingsDataUseCase
    let settingsField: [[SettingsField]] = [
        [SettingsField.help, SettingsField.email, SettingsField.legal],
        [SettingsField.delete]
    ]
    
    init(dependencies: SettingsDependency) {
        self.dependencies = dependencies
        self.coordinator = dependencies.resolve()
        self.settingsDataUseCase = dependencies.resolve()
    }
    func deleteProfile() {
        settingsDataUseCase.deleteProfile()
        coordinator?.performTransition(.goDeleteProfile)
    }
    func infoDeveloper(){
        coordinator?.performTransition(.goInfoDeveloper)
    }
    func goHelp() {
        coordinator?.performTransition(.goHelp)
    }
}



