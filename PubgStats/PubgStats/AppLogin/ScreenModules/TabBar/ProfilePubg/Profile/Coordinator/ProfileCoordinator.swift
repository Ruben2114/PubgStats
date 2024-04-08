//
//  ProfileCoordinator.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit
import SafariServices

public protocol ProfileCoordinator: BindableCoordinator {
    func goToAttributes(attributes: ProfileAttributesRepresentable)
    func goToAttributesDetails(_ attributes: ProfileAttributesDetailsRepresentable?)
    func goBack()
    func goToWeb(urlString: UrlType)
    func goToMatches()
}

final class ProfileCoordinatorImp: ProfileCoordinator {
    weak var navigation: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var onFinish: (() -> Void)?
    private let externalDependencies: ProfileExternalDependencies
    lazy var dataBinding: DataBinding = dependencies.resolve()
    private lazy var dependencies: Dependency = {
        Dependency(dependencies: externalDependencies, coordinator: self)
    }()
    
    public init(dependencies: ProfileExternalDependencies, navigation: UINavigationController?) {
        self.externalDependencies = dependencies
        self.navigation = navigation
    }
}

extension ProfileCoordinatorImp {
    func start() {
        self.navigation?.pushViewController(dependencies.resolve(), animated: true)
    }
    
    func goBack() {
        self.dismiss()
    }
    
    func goToAttributes(attributes: ProfileAttributesRepresentable) {
        let coordinator = dependencies.external.attributesHomeCoordinator(navigation: navigation)
        coordinator
            .set(attributes)
            .start()
        append(child: coordinator)
    }
    
    func goToAttributesDetails(_ attributes: ProfileAttributesDetailsRepresentable?) {
        let coordinator = dependencies.external.attributesDetailCoordinator(navigation: navigation)
        coordinator
            .set(attributes)
            .start()
        append(child: coordinator)
    }
    
    func goToWeb(urlString: UrlType) {
        guard let url = URL(string: urlString.rawValue) else { return }
        let safariService = SFSafariViewController(url: url)
        safariService.preferredBarTintColor = .black
        safariService.preferredControlTintColor = UIColor(red: 255/255, green: 205/255, blue: 61/255, alpha: 1)
        safariService.dismissButtonStyle = .close
        navigation?.present(safariService, animated: true)
    }
    
    func goToMatches() {
        
    }
}

private extension ProfileCoordinatorImp {
    struct Dependency: ProfileDependencies {
        let dependencies: ProfileExternalDependencies
        unowned let coordinator: ProfileCoordinator
        let dataBinding = DataBindingObject()
        
        var external: ProfileExternalDependencies {
            return dependencies
        }
        
        func resolve() -> ProfileCoordinator {
            return coordinator
        }
        
        func resolve()  -> DataBinding {
            return dataBinding
        }
    }
}
