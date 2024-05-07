//
//  AttributesDetailDependencies.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

protocol AttributesDetailDependencies {
    var external: AttributesDetailExternalDependencies { get }
    func resolve() -> AttributesDetailCoordinator
    func resolve() -> AttributesDetailViewController
    func resolve() -> AttributesDetailViewModel
    func resolve() -> DataBinding
}

extension AttributesDetailDependencies {
    func resolve() -> AttributesDetailViewController {
        AttributesDetailViewController(dependencies: self)
    }
    func resolve() -> AttributesDetailViewModel {
        AttributesDetailViewModel(dependencies: self)
    }
}
