//
//  AppDependencies.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 22/3/23.
//

import UIKit

struct AppDependencies {
    let window: UIWindow?
    private var tabController = UITabBarController()
    private let loginNavController = UINavigationController()
    private let profileNavController = UINavigationController()
    private let favouriteNavController = UINavigationController()
    private let rankingNavController = UINavigationController()
    private let guideNavController = UINavigationController()
    private let contactNavController = UINavigationController()
    private var sessionUser = ProfileEntity(name: "", password: "", email: "")
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func resolve() -> ProfileEntity {
        sessionUser
    }
    
    func resolve() -> AppDependencies {
        self
    }
    func resolve() -> UIWindow? {
        window
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
    func rankingNavigationController() -> UINavigationController {
        rankingNavController
    }
    func guideNavigationController() -> UINavigationController {
        guideNavController
    }
    func contactNavigationController() -> UINavigationController {
        contactNavController
    }
}
extension AppDependencies:
    LoginExternalDependency,
    ForgotExternalDependency,
    RegisterExternalDependency,
    MainTabBarExternalDependency,
    ProfileExternalDependency,
    FavouriteExternalDependency,
    RankingExternalDependency,
    GuideExternalDependency,
    ContactExternalDependency,
    StatsGeneralExternalDependency,
    KillsDataExternalDependency,
    WeaponDataExternalDependency,
    WeaponDataDetailExternalDependency,
    PersonalDataExternalDependency{}
