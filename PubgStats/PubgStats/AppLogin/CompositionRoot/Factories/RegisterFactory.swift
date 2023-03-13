//
//  RegisterFactory.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/3/23.
//

import Combine
import UIKit

protocol RegisterFactory {
    func makeModule(coordinator: RegisterViewControllerCoordinator) -> UIViewController
    func makeAcceptCoordinator(navigation: UINavigationController) -> Coordinator
    
}

struct RegisterFactoryImp : RegisterFactory {
    let appContainer: AppContainer
    
    func makeModule(coordinator: RegisterViewControllerCoordinator) -> UIViewController {
        let state = PassthroughSubject<StateController, Never>()
        let dataSource = LocalDataProfileServiceImp()
        let profileRepository = ProfileRepositoryImp(dataSource: dataSource)
        let profileDataUseCase = ProfileDataUseCaseImp(profileRepository: profileRepository)
        let viewModel = RegisterViewModel(state: state, profileDataUseCase: profileDataUseCase)
        let registerController = RegisterViewController(coordinator: coordinator, viewModel: viewModel)
        registerController.title = "Register"
        return registerController
    }
    func makeAcceptCoordinator(navigation: UINavigationController) -> Coordinator {
        let homeFactory = HomeFactoryImp(appContainer: appContainer)
        let homeCoordinator = HomeCoordinator(navigation: navigation, homeFactory: homeFactory)
        return homeCoordinator
        
    }
}
