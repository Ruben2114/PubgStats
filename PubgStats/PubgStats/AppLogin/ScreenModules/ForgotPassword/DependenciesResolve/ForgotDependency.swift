//
//  ForgotDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 22/3/23.
//

protocol ForgotDependency {
    var external: ForgotExternalDependency { get }
    func resolve() -> ForgotCoordinator
    func resolve() -> ForgotViewController
    func resolve() -> ForgotViewModel
}

extension ForgotDependency {
    func resolve() -> ForgotViewController {
        ForgotViewController(dependencies: self)
    }
    func resolve() -> ForgotViewModel {
        ForgotViewModel(dependencies: self)
    }
}
