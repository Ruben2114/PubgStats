//
//  PersonalDataDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 29/3/23.
//

protocol PersonalDataDependency {
    var external: PersonalDataExternalDependency { get }
    func resolve() -> PersonalDataCoordinator?
    func resolve() -> PersonalDataViewController
    func resolve() -> PersonalDataViewModel
}

extension PersonalDataDependency {
    func resolve() -> PersonalDataViewController {
        PersonalDataViewController(dependencies: self)
    }
    func resolve() -> PersonalDataViewModel {
        PersonalDataViewModel(dependencies: self)
    }
}
