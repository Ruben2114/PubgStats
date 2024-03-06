//
//  AttributesHomeDependencies.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

protocol AttributesHomeDependencies {
    var external: AttributesHomeExternalDependencies { get }
    func resolve() -> AttributesHomeCoordinator
    func resolve() -> AttributesHomeViewController
    func resolve() -> AttributesHomeViewModel
    func resolve() -> DataBinding
}

extension AttributesHomeDependencies {
    func resolve() -> AttributesHomeViewController {
        AttributesHomeViewController(dependencies: self)
    }
    func resolve() -> AttributesHomeViewModel {
        AttributesHomeViewModel(dependencies: self)
    }
}
