//
//  HelpDataViewModel.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 29/3/23.
//

final class HelpDataViewModel {
    private let dependencies: HelpDataDependencies
    
    init(dependencies: HelpDataDependencies) {
        self.dependencies = dependencies
    }
    
    func backButton() {
        coordinator.goBack()
    }
}

private extension HelpDataViewModel {
    var coordinator: HelpDataCoordinator {
        return dependencies.resolve()
    }
}
