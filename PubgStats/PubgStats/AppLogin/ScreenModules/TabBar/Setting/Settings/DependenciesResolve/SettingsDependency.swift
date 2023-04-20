//
//  SettingsDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

protocol SettingsDependency {
    var external: SettingsExternalDependency { get }
    func resolve() -> SettingsViewController
    func resolve() -> SettingsViewModel
    func resolve() -> SettingsCoordinator?
    func resolve() -> SettingsDataUseCase
    func resolve() -> SettingsDataRepository
}

extension SettingsDependency {
    func resolve() -> SettingsViewController {
        SettingsViewController(dependencies: self)
    }
    func resolve() -> SettingsViewModel {
        SettingsViewModel(dependencies: self)
    }
    func resolve() -> SettingsDataUseCase {
        SettingsDataUseCaseImp(dependencies: self)
    }
    func resolve() -> SettingsDataRepository {
        SettingsDataRepositoryImp(dependencies: self)
    }
}
