//
//  HomeFactory.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/3/23.
//
import UIKit
import Combine

protocol HomeFactory {
    func makeModule(coordinator: HomeMenuViewControllerCoordinator) -> UIViewController
    func makeLoginCoordinator() -> Coordinator
    func makeForgotCoordinator() -> Coordinator
    func makeRegisterCoordinator() -> Coordinator
}

struct HomeFactoryImp: HomeFactory {
    private(set) var appContainer: AppContainer
    
    func makeModule(coordinator: HomeMenuViewControllerCoordinator) -> UIViewController {
        let loginRepository = LoginRepositoryImp(dataSource: appContainer.localDataService)
        let loginDataUseCase = LoginDataUseCaseImp(loginRepository: loginRepository)
        let viewModel = HomeMenuViewModel( loginDataUseCase: loginDataUseCase)
        let homeMenuController = HomeMenuViewController(viewModel: viewModel, coordinator: coordinator)
        homeMenuController.title = "Login"
        return homeMenuController
    }
    func makeForgotCoordinator() -> Coordinator {
        let forgotfactory = ForgotFactoryImp(appContainer: appContainer)
        let forgotCoordinator = ForgotCoordinator( forgotFactory: forgotfactory)
        return forgotCoordinator
    }

    func makeLoginCoordinator() -> Coordinator {
        let tabBarFactory = TabBarFactoryImp(appContainer: appContainer)
        let tabBarCoordinator = TabBarCoordinator( tabBarFactory: tabBarFactory)
        return tabBarCoordinator
    }
    
    func makeRegisterCoordinator() -> Coordinator {
        let registerFactory = RegisterFactoryImp(appContainer: appContainer)
        let registerCoordinator = RegisterCoordinator( registerFactory: registerFactory)
        return registerCoordinator
    }
}
