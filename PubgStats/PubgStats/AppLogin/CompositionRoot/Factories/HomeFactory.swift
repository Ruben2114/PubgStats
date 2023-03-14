//
//  HomeFactory.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/3/23.
//
import UIKit

protocol HomeFactory {
    func makeModule(coordinator: HomeMenuViewControllerCoordinator) -> UIViewController
    func makeLoginCoordinator(navigation: UINavigationController) -> Coordinator
    func makeRegisterCoordinator(navigation: UINavigationController) -> Coordinator
}

struct HomeFactoryImp: HomeFactory {
    private(set) var appContainer: AppContainer
    
    func makeModule(coordinator: HomeMenuViewControllerCoordinator) -> UIViewController {
        let loginRepository = LoginRepositoryImp(dataSource: appContainer.localDataService)
        let loginDataUseCase = LoginDataUseCaseImp(loginRepository: loginRepository)
        let viewModel = HomeMenuViewModel(loginDataUseCase: loginDataUseCase)
        let homeMenuController = HomeMenuViewController(viewModel: viewModel, coordinator: coordinator)
        homeMenuController.title = "Login"
        return homeMenuController
    }
    func makeLoginCoordinator(navigation: UINavigationController) -> Coordinator {
        let profileFactory = ProfileFactoryImp(appContainer: appContainer)
        let profileCoordinator = ProfileCoordinator(navigation: navigation, profileFactory: profileFactory)
        return profileCoordinator
    }
    
    func makeRegisterCoordinator(navigation: UINavigationController) -> Coordinator {
        let registerFactory = RegisterFactoryImp(appContainer: appContainer)
        let registerCoordinator = RegisterCoordinator(navigation: navigation, registerFactory: registerFactory)
        return registerCoordinator
    }
}
