//
//  AttributesHomeCoordinatorSpy.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 19/2/24.
//

import PubgStats
import UIKit

final class AttributesHomeCoordinatorSpy: AttributesHomeCoordinator {
    var dataBinding: DataBinding
    var childCoordinators: [Coordinator] = []
    var navigation: UINavigationController?
    var onFinish: (() -> Void)?
    var goToAttributesDetails = false
    var goToBack = false
    
    init() {
        childCoordinators = []
        dataBinding = DataBindingObject()
    }
    
    func start() {}
    
    func goToAttributesDetails(_ attributes: ProfileAttributesDetailsRepresentable?) {
        goToAttributesDetails =  true
    }
    
    func goBack() {
        goToBack = true
    }
}
