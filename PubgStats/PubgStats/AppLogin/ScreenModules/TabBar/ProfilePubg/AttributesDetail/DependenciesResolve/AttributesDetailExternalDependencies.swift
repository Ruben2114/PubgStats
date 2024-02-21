//
//  AttributesDetailExternalDependencies.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

import UIKit

protocol AttributesDetailExternalDependencies {
    func attributesDetailCoordinator(navigation: UINavigationController?) -> BindableCoordinator
}

extension AttributesDetailExternalDependencies {
    func attributesDetailCoordinator(navigation: UINavigationController?) -> BindableCoordinator {
        AttributesDetailCoordinatorImp(dependencies: self, navigation: navigation)
    }
}
