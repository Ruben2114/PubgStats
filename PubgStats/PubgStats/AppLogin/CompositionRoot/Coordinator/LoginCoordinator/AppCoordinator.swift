//
//  AppCoordinator.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/3/23.
//
import UIKit

final class AppCoordinator: Coordinator {
    var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    
    private let appFactory: AppFactory
    
    init(navigation: UINavigationController, appFactory: AppFactory, window: UIWindow?){
        self.navigation = navigation
        self.appFactory = appFactory
        configWindow(window: window)
    }
    func start() {
        let coordinator = appFactory.makeHomeCoordinator(navigation: navigation!)
        coordinator.start()
        append(child: coordinator)
    }
    
    private func configWindow(window: UIWindow?) {
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
}
