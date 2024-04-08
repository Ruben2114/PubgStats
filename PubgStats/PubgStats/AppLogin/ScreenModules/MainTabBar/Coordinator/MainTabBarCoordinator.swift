//
//  MainTabBarCoordinator.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

protocol MainTabBarCoordinator: Coordinator { }

final class MainTabBarCoordinatorImp: MainTabBarCoordinator {
    lazy var dataBinding: DataBinding = dependencies.resolve()
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: MainTabBarExternalDependency
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies, coordinator: self)
    }()
    private var dataProfile: IdAccountDataProfileRepresentable?
    
    public init(dependencies: MainTabBarExternalDependency, data: IdAccountDataProfileRepresentable?) {
        self.externalDependencies = dependencies
        self.dataProfile = data
    }
    
    func start() {
        let tabBarView = TabBarView.getTabBar(externalDependencies)
            .map({createNavController(tabBar: $0, data: dataProfile)})
        let tabBar = dependencies.external.tabBarController()
        tabBar.viewControllers = tabBarView
        tabBar.tabBar.backgroundColor = .black
        tabBar.tabBar.tintColor = UIColor(red: 255/255, green: 205/255, blue: 61/255, alpha: 1)
        tabBar.tabBar.unselectedItemTintColor = .systemGray
    }
    
    func dismiss() {
        dependencies.external.settingsNavigationController().viewControllers = []
        dependencies.external.profileNavigationController().viewControllers = []
        dependencies.external.favouriteNavigationController().viewControllers = []
        childCoordinators.removeAll()
    }
}

private extension MainTabBarCoordinatorImp {
    func createNavController(tabBar: TabBarView, data: IdAccountDataProfileRepresentable?) -> UINavigationController {
        let navigation = tabBar.getNavigation()
        var coordinator = tabBar.getCoordinator()
        navigation.viewControllers = []
        navigation.tabBarItem.title = tabBar.getTitle().localize()
        navigation.tabBarItem.image = UIImage(systemName: tabBar.getImage())
        if let bindableCoordinator = coordinator as? ProfileCoordinator {
            let type: NavigationStats = .profile
            coordinator = bindableCoordinator
                .set(type)
                .set(data)
            coordinator.start()
        } else {
            coordinator.start()
        }
        append(child: coordinator)
        return navigation
    }
}

private extension MainTabBarCoordinatorImp {
    struct Dependency: MainTabBarDependency {
        let external: MainTabBarExternalDependency
        unowned var coordinator: MainTabBarCoordinator
        let dataBinding = DataBindingObject()
        
        func resolve() -> MainTabBarCoordinator {
            return coordinator
        }
        
        func resolve() -> DataBinding {
            dataBinding
        }
    }
}
