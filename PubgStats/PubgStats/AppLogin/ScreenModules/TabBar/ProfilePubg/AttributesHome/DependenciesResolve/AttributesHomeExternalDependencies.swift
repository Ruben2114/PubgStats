//
//  AttributesHomeExternalDependencies.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

import UIKit

protocol AttributesHomeExternalDependencies {
    func attributesHomeCoordinator(navigation: UINavigationController?) -> BindableCoordinator
    func attributesDetailCoordinator(navigation: UINavigationController?) -> BindableCoordinator
}

extension AttributesHomeExternalDependencies {
    func attributesHomeCoordinator(navigation: UINavigationController?) -> BindableCoordinator {
        AttributesHomeCoordinatorImp(dependencies: self, navigation: navigation)
    }
}
