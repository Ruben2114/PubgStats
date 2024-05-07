//
//  MainTabBarViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 29/4/24.
//

import Foundation
import Combine

final class MainTabBarViewModel {
    private let dependencies: MainTabBarDependencies
    
    init(dependencies: MainTabBarDependencies) {
        self.dependencies = dependencies
    }
    
    func tabBarSelect(_ item: String) {
        coordinator.tabBarSelect(item)
    }
}

private extension MainTabBarViewModel {
    var coordinator: MainTabBarCoordinator {
        return dependencies.resolve()
    }
}
