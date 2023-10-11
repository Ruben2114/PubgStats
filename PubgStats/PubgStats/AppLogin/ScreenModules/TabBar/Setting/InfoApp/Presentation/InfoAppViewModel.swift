//
//  InfoAppViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 17/4/23.
//

final class InfoAppViewModel {
    private let dependencies: InfoAppDependency
    private weak var coordinator: InfoAppCoordinator?
    
    init(dependencies: InfoAppDependency) {
        self.dependencies = dependencies
        self.coordinator = dependencies.resolve()
    }
    let info: String = "infoAppViewModel".localize()
    func backButton() {
        coordinator?.dismiss()
    }
}
