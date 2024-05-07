//
//  HelpDataExternalDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 29/3/23.
//

import UIKit

protocol HelpDataExternalDependencies {
    func helpDataCoordinator(navigation: UINavigationController?) -> Coordinator
}

extension HelpDataExternalDependencies {
    func helpDataCoordinator(navigation: UINavigationController?) -> Coordinator {
        HelpDataCoordinatorImp(dependencies: self, navigation: navigation)
    }
}
