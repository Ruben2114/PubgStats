//
//  SettingsDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

protocol SettingsDependencies {
    var external: SettingsExternalDependencies { get }
    func resolve() -> SettingsViewController
    func resolve() -> SettingsViewModel
    func resolve() -> SettingsCoordinator
    func resolve() -> SettingsDataUseCase
    func resolve() -> DataBinding
}

extension SettingsDependencies {
    func resolve() -> SettingsViewController {
        SettingsViewController(dependencies: self)
    }
    
    func resolve() -> SettingsViewModel {
        SettingsViewModel(dependencies: self)
    }
    
    func resolve() -> SettingsDataUseCase {
        SettingsDataUseCaseImp(dependencies: self)
    }
}
