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
    private let sessionUser: ProfileEntity
    let itemsSettings = [
        ["Dudas frecuentes", "Correo", "Aviso Legal"],
        ["Borrar Perfil"]
    ]
    let imageSettings = [
        ["questionmark.circle.fill", "envelope.circle.fill", "info.circle.fill"],
        ["trash.circle.fill"]
    ]
    init(dependencies: SettingsDependency) {
        self.dependencies = dependencies
        self.coordinator = dependencies.resolve()
        self.sessionUser = dependencies.external.resolve()
        self.settingsDataUseCase = dependencies.resolve()
    }
    
    func deleteProfile() {
        settingsDataUseCase.deleteProfile(sessionUser: sessionUser)
        coordinator?.performTransition(.goDeleteProfile)
    }
    func infoDeveloper(){
        coordinator?.performTransition(.goInfoDeveloper)
    }
    func goHelp() {
        coordinator?.performTransition(.goHelp)
    }
}



