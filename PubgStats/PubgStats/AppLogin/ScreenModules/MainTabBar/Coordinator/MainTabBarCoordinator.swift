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
        //TODO: cambiar esto por matches y guide en una totalizator en la view (en favoritos en matches se cambian por la view de noticias)
        let tabBar = dependencies.external.tabBarController()
        tabBar.viewControllers = tabBarView
        tabBar.tabBar.backgroundColor = .white
    }
    
    func dismiss() {
        dependencies.external.settingsNavigationController().viewControllers = []
        dependencies.external.profileNavigationController().viewControllers = []
        dependencies.external.guideNavigationController().viewControllers = []
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
        if let bindableCoordinator = coordinator as? BindableCoordinator {
            coordinator = bindableCoordinator.set(data)
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
