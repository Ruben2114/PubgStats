//
//  AttributesDetailCoordinatorSpy.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 21/2/24.
//

import PubgStats
import UIKit

final class AttributesDetailCoordinatorSpy: AttributesDetailCoordinator {
    var dataBinding: DataBinding
    var childCoordinators: [Coordinator] = []
    var navigation: UINavigationController?
    var onFinish: (() -> Void)?
    var goToBack = false
    
    init() {
        dataBinding = DataBindingObject()
    }
    
    func start() {}
    
    func goBack() {
        goToBack = true
    }
}
