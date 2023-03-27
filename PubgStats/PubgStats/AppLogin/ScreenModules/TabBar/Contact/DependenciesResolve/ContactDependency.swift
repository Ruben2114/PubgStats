//
//  ContactDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

protocol ContactDependency {
    var external: ContactExternalDependency { get }
    func resolve() -> ContactViewController
    func resolve() -> ContactCoordinator?
}

extension ContactDependency {
    func resolve() -> ContactViewController {
        ContactViewController(dependencies: self)
    }
}
