//
//  ProfileCoordinatorSpy.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 19/2/24.
//

import PubgStats
import UIKit

final class ProfileCoordinatorSpy: ProfileCoordinator {
    var dataBinding: DataBinding
    var childCoordinators: [Coordinator] = []
    var navigation: UINavigationController?
    var onFinish: (() -> Void)?
    var goToAttributes = false
    var goToAttributesDetails = false
    
    init() {
        childCoordinators = []
        dataBinding = DataBindingObject()
    }
    
    func start() {}
    
    func goToAttributes(attributes: ProfileAttributesRepresentable) {
        goToAttributes = true
    }
    
    func goToAttributesDetails(_ attributes: ProfileAttributesDetailsRepresentable?) {
        goToAttributesDetails =  true
    }
}
