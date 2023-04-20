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
    let info: String = "Acerca de PubgStats\n\nPubgStats es una aplicación creada por Rubén Rodríguez. Graduado en Programación de aplicaciones móviles con Swift en TokioSchool\n\nEsta aplicación ha sido creada con el objetivo de poder analizar las estadísticas de los diferentes usuarios del juego PUBG. Además ofrece un acceso a la guia oficial donde podrás ver todas las novedades y actualizaciones.\n\nA través de la creación de esta aplicación puedo mostrar los conocimientos adquiridos durante el curso y las prácticas curriculares en la entrega del TFM\n\nSi tienes alguna duda, sugerencia o problema con la ejecución de la app no dudes en contactar a través del correo situado en la zona de Ajustes."
    func backButton() {
        coordinator?.dismiss()
    }
}
