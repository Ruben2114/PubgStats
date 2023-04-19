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
        "La recarga de los datos esta limitada por los servidores, si usted decide recargar podrá realizar dicha recarga 1 vez cada 2 horas. Sino automaticamente los datos se recargaran cada 12 horas desde su última búsqueda",
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
