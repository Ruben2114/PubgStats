//
//  MainTabBarCoordinator.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

protocol MainTabBarCoordinator: Coordinator { }

final class MainTabBarCoordinatorImp: Coordinator {
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: MainTabBarExternalDependency
    private lazy var dependencies: Dependency = {
        Dependency(external: externalDependencies, coordinator: self)
    }()
    
    public init(dependencies: MainTabBarExternalDependency) {
        self.externalDependencies = dependencies
    }
    
    func start() {
        
        var viewControllers = [UIViewController]()
        
        let profileCoordinator = dependencies.external.profileCoordinator()
        let profileNavController = dependencies.external.profileNavigationController()
        profileNavController.viewControllers = []
        profileNavController.tabBarItem.title = "Profile"
        profileNavController.tabBarItem.image = UIImage(systemName: "person.circle.fill")
        viewControllers.append(profileNavController)
        profileCoordinator.start()
        append(child: profileCoordinator)
        
        let favouriteCoordinator = dependencies.external.favouriteCoordinator()
        let favouriteNavController = dependencies.external.favouriteNavigationController()
        favouriteNavController.viewControllers = []
        favouriteNavController.tabBarItem.title = "Favourite"
        favouriteNavController.tabBarItem.image = UIImage(systemName: "star.circle.fill")
        viewControllers.append(favouriteNavController)
        favouriteCoordinator.start()
        append(child: favouriteCoordinator)
       
        let rankingCoordinator = dependencies.external.rankingCoordinator()
        let rankingNavController = dependencies.external.rankingNavigationController()
        rankingNavController.viewControllers = []
        rankingNavController.tabBarItem.title = "Ranking"
        rankingNavController.tabBarItem.image = UIImage(systemName: "trophy.circle.fill")
        viewControllers.append(rankingNavController)
        rankingCoordinator.start()
        append(child: rankingCoordinator)
        
        let guideCoordinator = dependencies.external.guideCoordinator()
        let guideNavController = dependencies.external.guideNavigationController()
        guideNavController.viewControllers = []
        guideNavController.tabBarItem.title = "Guide"
        guideNavController.tabBarItem.image = UIImage(systemName: "book.circle.fill")
        viewControllers.append(guideNavController)
        guideCoordinator.start()
        append(child: guideCoordinator)
        
        let contactCoordinator = dependencies.external.contactCoordinator()
        let contactNavController = dependencies.external.contactNavigationController()
        contactNavController.viewControllers = []
        contactNavController.tabBarItem.title = "Contact"
        contactNavController.tabBarItem.image = UIImage(systemName: "envelope.circle.fill")
        viewControllers.append(contactNavController)
        contactCoordinator.start()
        append(child: contactCoordinator)
        
        let tabBar = dependencies.external.tabBarController()
        tabBar.viewControllers = viewControllers
        tabBar.tabBar.backgroundColor = .white
    }
    func dismiss() {
        dependencies.external.contactNavigationController().viewControllers = []
        dependencies.external.profileNavigationController().viewControllers = []
        dependencies.external.guideNavigationController().viewControllers = []
        dependencies.external.favouriteNavigationController().viewControllers = []
        dependencies.external.rankingNavigationController().viewControllers = []
    }
    
}
extension MainTabBarCoordinatorImp: MainTabBarCoordinator{ }
private extension MainTabBarCoordinatorImp {
    struct Dependency: MainTabBarDependency {
        let external: MainTabBarExternalDependency
        weak var coordinator: MainTabBarCoordinator?
        
        func resolve() -> MainTabBarCoordinator? {
            return coordinator
        }
    }
}
