//
//  AppDependencies.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 22/3/23.
//

import UIKit

struct AppDependencies {
    let window: UIWindow?
    private let localDataService = LocalDataProfileServiceImp()
    private let remoteDataService = RemoteServiceImp()
    private var tabController = UITabBarController()
    private let loginNavController = UINavigationController()
    private let profileNavController = UINavigationController()
    private let favouriteNavController = UINavigationController()
    private let guideNavController = UINavigationController()
    private let settingsNavController = UINavigationController()
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func resolve() -> LocalDataProfileService {
        localDataService
    }
    
    func resolve() -> RemoteService {
        remoteDataService
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
    
    func loginNavigationController() -> UINavigationController {
        loginNavController
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
    
    func guideNavigationController() -> UINavigationController {
        guideNavController
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
    GuideExternalDependency,
    SettingsExternalDependency,
    HelpDataExternalDependency,
    AttributesHomeExternalDependencies,
    AttributesDetailExternalDependencies,
    InfoAppExternalDependency{}
