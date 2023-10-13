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
    private var dataProfile: DefaultIdAccountDataProfileRepresentable?
    
    public init(dependencies: MainTabBarExternalDependency, player: String, id: String) {
        self.externalDependencies = dependencies
        self.dataProfile = DefaultIdAccountDataProfileRepresentable(id: id, name: player)
    }
    
    func start() {
        
        var viewControllers = [UIViewController]()
        
        let profileCoordinator = dependencies.external.profileCoordinator()
        let profileNavController = dependencies.external.profileNavigationController()
        profileNavController.viewControllers = []
        profileNavController.tabBarItem.title = "profileTabBarItem".localize()
        profileNavController.tabBarItem.image = UIImage(systemName: "person.circle.fill")
        viewControllers.append(profileNavController)
        profileCoordinator.set(dataProfile).start()
        append(child: profileCoordinator)
        
        let favouriteCoordinator = dependencies.external.favouriteCoordinator()
        let favouriteNavController = dependencies.external.favouriteNavigationController()
        favouriteNavController.viewControllers = []
        favouriteNavController.tabBarItem.title = "favouriteTabBarItem".localize()
        favouriteNavController.tabBarItem.image = UIImage(systemName: "star.circle.fill")
        viewControllers.append(favouriteNavController)
        favouriteCoordinator.start()
        append(child: favouriteCoordinator)
        
        let guideCoordinator = dependencies.external.guideCoordinator()
        let guideNavController = dependencies.external.guideNavigationController()
        guideNavController.viewControllers = []
        guideNavController.tabBarItem.title = "guideTabBarItem".localize()
        guideNavController.tabBarItem.image = UIImage(systemName: "book.circle.fill")
        viewControllers.append(guideNavController)
        guideCoordinator.start()
        append(child: guideCoordinator)
        
        let settingsCoordinator = dependencies.external.settingsCoordinator()
        let settingsNavController = dependencies.external.settingsNavigationController()
        settingsNavController.viewControllers = []
        settingsNavController.tabBarItem.title = "settingsTabBarItem".localize()
        settingsNavController.tabBarItem.image = UIImage(systemName: "gear.circle.fill")
        viewControllers.append(settingsNavController)
        settingsCoordinator.start()
        append(child: settingsCoordinator)
        
        let tabBar = dependencies.external.tabBarController()
        tabBar.viewControllers = viewControllers
        tabBar.tabBar.backgroundColor = .white
    }
    func dismiss() {
        dependencies.external.settingsNavigationController().viewControllers = []
        dependencies.external.profileNavigationController().viewControllers = []
        dependencies.external.guideNavigationController().viewControllers = []
        dependencies.external.favouriteNavigationController().viewControllers = []
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
