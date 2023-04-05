//
//  RegisterDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 22/3/23.
//

protocol RegisterDependency {
    var external: RegisterExternalDependency { get }
    func resolve() -> RegisterViewController
    func resolve() -> RegisterViewModel
    func resolve() -> RegisterCoordinator?
    func resolve() -> RegisterDataUseCase
    func resolve() -> RegisterRepository
}
extension RegisterDependency {
    func resolve() -> RegisterViewController {
        RegisterViewController(dependencies: self)
    }
    func resolve() -> RegisterViewModel {
        RegisterViewModel(dependencies: self)
    }
    func resolve() -> RegisterDataUseCase {
        RegisterDataUseCaseImp(dependencies: self)
    }
    func resolve() -> RegisterRepository {
        RegisterRepositoryImp(dependencies: self)
    }
}
