//
//  HomeFactory.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/3/23.
//
import UIKit

protocol HomeFactory {
    func makeModule(coordinator: HomeMenuViewControllerCoordinator) -> UIViewController
    func makeLoginCoordinator() -> Coordinator
    func makeForgotCoordinator(navigation: UINavigationController) -> Coordinator
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
    func makeLoginCoordinator() -> Coordinator {
        let changeTabBarCoordinator = ChangeTabBarCoordinator()
        return changeTabBarCoordinator
    }
    func makeForgotCoordinator(navigation: UINavigationController) -> Coordinator {
        let forgotFactory = ForgotFactoryImp(appContainer: appContainer)
        let forgotCoordinator = ForgotCoordinator(navigation: navigation, forgotFactory: forgotFactory)
        return forgotCoordinator
    }
    
    func makeRegisterCoordinator(navigation: UINavigationController) -> Coordinator {
        let registerFactory = RegisterFactoryImp(appContainer: appContainer)
        let registerCoordinator = RegisterCoordinator(navigation: navigation, registerFactory: registerFactory)
        return registerCoordinator
    }
}
