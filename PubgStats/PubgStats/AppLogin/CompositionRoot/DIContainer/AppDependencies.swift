//
//  AppDependencies.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 22/3/23.
//

import UIKit

struct AppDependencies {
    private var tabController = UITabBarController()
    private let profileNavController = UINavigationController()
    private let favouriteNavController = UINavigationController()
    private let settingsNavController = UINavigationController()
    
    init() { }
    
    func resolve() -> LocalDataProfileService {
        LocalDataProfileServiceImp()
    }
    
    func resolve() -> RemoteService {
        RemoteServiceImp()
    }
    
    func resolve() -> DataPlayerRepository {
        DataPlayerRepositoryImp(dependencies: self)
    }
    
    func resolve() -> FavouritePlayerRepository {
        FavouriteRepositoryImp(dependencies: self)
    }
    
    //TODO: intentar borrarla de todos lados
    func resolve() -> AppDependencies {
        self
    }
    
    func profileNavigationController() -> UINavigationController {
        profileNavController
    }
    
    func tabBarController() -> UITabBarController {
        tabController
    }
    
    func favouriteNavigationController() -> UINavigationController {
        favouriteNavController
    }
    
    func settingsNavigationController() -> UINavigationController {
        settingsNavController
    }
}

extension AppDependencies:
    LoginExternalDependencies,
    MainTabBarExternalDependency,
    ProfileExternalDependencies,
    FavouriteExternalDependencies,
    SettingsExternalDependencies,
    HelpDataExternalDependency,
    AttributesHomeExternalDependencies,
    AttributesDetailExternalDependencies,
    MatchesExternalDependencies{}
