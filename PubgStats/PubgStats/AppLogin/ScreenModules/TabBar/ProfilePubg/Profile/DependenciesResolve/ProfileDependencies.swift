//
//  ProfileDependencies.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

protocol ProfileDependencies {
    var external: ProfileExternalDependencies { get }
    func resolve() -> ProfileViewController
    func resolve() -> ProfileViewModel
    func resolve() -> ProfileDataUseCase
    func resolve() -> DataBinding
    func resolve() -> ProfileCoordinator
}

extension ProfileDependencies {
    func resolve() -> ProfileViewController {
        ProfileViewController(dependencies: self)
    }
    
    func resolve() -> ProfileViewModel {
        ProfileViewModel(dependencies: self)
    }
    
    func resolve() -> ProfileDataUseCase {
        ProfileDataUseCaseImp(dependencies: self)
    }
}
