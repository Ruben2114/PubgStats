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
}

extension LoginDependency {

    func resolve() -> LoginViewController {
        LoginViewController(dependencies: self)
    }
    
    func resolve() -> LoginViewModel {
        LoginViewModel(dependencies: self)
    }
    
    func resolve() -> LoginDataUseCase {
        let dataSource = AppContainerImp().localDataService
        let loginRepository = LoginRepositoryImp(dataSource: dataSource)
        let loginDataUseCase = LoginDataUseCaseImp(loginRepository: loginRepository)
        return loginDataUseCase
    }
}
