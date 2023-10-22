//
//  ProfileDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

protocol ProfileDependency {
    var external: ProfileExternalDependency { get }
    func resolve() -> ProfileViewController
    func resolve() -> ProfileViewModel
    func resolve() -> ProfileCoordinator?
    func resolve() -> ProfileDataUseCase
    func resolve() -> DataBinding
    func resolve() -> ProfileCoordinator
}

extension ProfileDependency {
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
