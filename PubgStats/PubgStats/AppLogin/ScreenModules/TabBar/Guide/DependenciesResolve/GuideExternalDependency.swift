//
//  GuideExternalDependency.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 23/3/23.
//

import UIKit

protocol GuideExternalDependency {
    func resolve() -> AppDependencies
    func guideCoordinator() -> Coordinator
    func guideNavigationController() -> UINavigationController
}
extension GuideExternalDependency {
    func guideCoordinator() -> Coordinator {
        GuideCoordinatorImp(dependencies: self)
    }
}
