//
//  LoginDependencies.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 22/3/23.
//

protocol LoginDependencies {
    var external: LoginExternalDependencies { get }
    func resolve() -> LoginViewController
    func resolve() -> LoginViewModel
    func resolve() -> LoginCoordinator
    func resolve() -> LoginDataUseCase
}

extension LoginDependencies {

    func resolve() -> LoginViewController {
        LoginViewController(dependencies: self)
    }
    
    func resolve() -> LoginViewModel {
        LoginViewModel(dependencies: self)
    }
    
    func resolve() -> LoginDataUseCase {
        LoginDataUseCaseImp(dependencies: self)
    }
}
