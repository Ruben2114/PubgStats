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
}

extension ProfileDependency {
    func resolve() -> ProfileViewController {
        ProfileViewController(dependencies: self)
    }
    
    func resolve() -> ProfileViewModel {
        ProfileViewModel(dependencies: self)
    }
    
    func resolve() -> ProfileDataUseCase {
        let dataSource = AppContainerImp().localDataService
        let profileRepository = ProfileRepositoryImp(dataSource: dataSource)
        let profileDataUseCase = ProfileDataUseCaseImp(profileRepository: profileRepository)
        return profileDataUseCase
    }
}
