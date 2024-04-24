//
//  HelpDataDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 29/3/23.
//

protocol HelpDataDependencies {
    var external: HelpDataExternalDependencies { get }
    func resolve() -> HelpDataCoordinator
    func resolve() -> HelpDataViewController
    func resolve() -> HelpDataViewModel
}

extension HelpDataDependencies {
    func resolve() -> HelpDataViewController {
        HelpDataViewController(dependencies: self)
    }
    func resolve() -> HelpDataViewModel {
        HelpDataViewModel(dependencies: self)
    }
}
