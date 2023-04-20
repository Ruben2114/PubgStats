//
//  LoginDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 22/3/23.
//

protocol LoginDependency {
    var external: LoginExternalDependency { get }
    func resolve() -> LoginViewController
    func resolve() -> LoginViewModel
    func resolve() -> LoginCoordinator?
    func resolve() -> LoginDataUseCase
    func resolve() -> LoginRepository
}

extension LoginDependency {

    func resolve() -> LoginViewController {
        LoginViewController(dependencies: self)
    }
    func resolve() -> LoginViewModel {
        LoginViewModel(dependencies: self)
    }
    func resolve() -> LoginRepository {
        LoginRepositoryImp(dependencies: self)
    }
    func resolve() -> LoginDataUseCase {
        LoginDataUseCaseImp(dependencies: self)
    }
}
