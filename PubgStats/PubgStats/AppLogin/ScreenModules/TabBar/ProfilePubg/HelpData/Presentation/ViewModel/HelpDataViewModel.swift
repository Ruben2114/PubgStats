//
//  HelpDataViewModel.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 29/3/23.
//

final class HelpDataViewModel {
    let questions = [
        "¿Cuando se recargan los datos?",
        "¿Cómo borro a los usuarios favoritos de mi lista?"
    ]
    let response = [
        "La recarga de los datos esta limitada por los servidores, si usted decide recargar o buscar  datos gran cantidad de veces puede ser que sufra una demora de tiempo considerable",
        "Desliza el perfil de tu lista hacia la izquierda"
    ]
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
