//
//  MainTabBarDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

protocol MainTabBarDependencies {
    var external: MainTabBarExternalDependencies { get }
    func resolve() -> MainTabBarController
    func resolve() -> MainTabBarViewModel
    func resolve() -> MainTabBarCoordinator
}

extension MainTabBarDependencies {
    func resolve() -> MainTabBarController {
        MainTabBarController(dependencies: self)
    }
    
    func resolve() -> MainTabBarViewModel {
        MainTabBarViewModel(dependencies: self)
    }
}
