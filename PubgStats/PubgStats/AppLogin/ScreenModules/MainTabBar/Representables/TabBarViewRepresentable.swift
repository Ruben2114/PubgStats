//
//  TabBarViewRepresentable.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 22/2/24.
//

import UIKit

enum TabBarView {
    case profile(MainTabBarExternalDependency)
    case favourite(MainTabBarExternalDependency)
    case setting(MainTabBarExternalDependency)
    
    static func getTabBar(_ dependencies: MainTabBarExternalDependency) -> [TabBarView] {
        return  [.profile(dependencies),
                 .favourite(dependencies),
                 .setting(dependencies)]
    }

    func getTitle() -> String {
        switch self {
        case .profile:
            return "profileTabBarItem"
        case .favourite:
            return "favouriteTabBarItem"
        case .setting:
            return "settingsTabBarItem"
        }
    }
    
    func getImage() -> String {
        switch self {
        case .profile:
            return "person.circle.fill"
        case .favourite:
            return "star.circle.fill"
        case .setting:
            return "gear.circle.fill"
        }
    }
    
    func getNavigation() -> UINavigationController {
        switch self {
        case .profile(let dependencies):
            return dependencies.profileNavigationController()
        case .favourite(let dependencies):
            return dependencies.favouriteNavigationController()
        case .setting(let dependencies):
            return dependencies.settingsNavigationController()
        }
    }
    
    func getCoordinator() -> Coordinator {
        switch self {
        case .profile(let dependencies):
            return dependencies.profileCoordinator(navigation: dependencies.profileNavigationController())
        case .favourite(let dependencies):
            return dependencies.favouriteCoordinator(navigation: dependencies.favouriteNavigationController())
        case .setting(let dependencies):
            return dependencies.settingsCoordinator()
        }
    }
}

