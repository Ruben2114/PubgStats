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
}
extension RegisterDependency {
    func resolve() -> RegisterViewController {
        RegisterViewController(dependencies: self)
    }
    
    func resolve() -> RegisterViewModel {
        RegisterViewModel(dependencies: self)
    }
    
    func resolve() -> RegisterDataUseCase {
        let dataSource = AppContainerImp().localDataService
        let registerRepository = RegisterRepositoryImp(dataSource: dataSource)
        let registerDataUseCase = RegisterDataUseCaseImp(registerRepository: registerRepository)
        return registerDataUseCase
    }
}
