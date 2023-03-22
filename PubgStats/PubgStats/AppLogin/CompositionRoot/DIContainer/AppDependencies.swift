//
//  AppDependencies.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 22/3/23.
//

import UIKit

struct AppDependencies {
    let window: UIWindow?
    private let loginNavController = UINavigationController()
    private let profileNavController = UINavigationController()
    private let favouriteNavController = UINavigationController()
    private let rankingNavController = UINavigationController()
    private let guideNavController = UINavigationController()
    private let contactNavController = UINavigationController()
    
    init(window: UIWindow?) {
        self.window = window
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
}
extension AppDependencies:
    LoginExternalDependency, ForgotExternalDependency{
}


