//
//  HelpDataViewModel.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 29/3/23.
//

final class HelpDataViewModel {
    private let dependencies: HelpDataDependency
    private weak var coordinator: HelpDataCoordinator?
    
    init(dependencies: HelpDataDependency) {
        self.dependencies = dependencies
        self.coordinator = dependencies.resolve()
    }
    func backButton() {
        coordinator?.dismiss()
    }
}
