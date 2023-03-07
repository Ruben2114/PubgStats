//
//  FlujosDeNavegacion.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 7/3/23.
//

import UIKit

//TODO: meter el tema de la navegacion

protocol FlujosDeNavegacionDependencias {
    //meter las dependencias necesarias del DIContainer
}

final class FlujosDeNavegacion {
    
    private weak var navigationController: UINavigationController?
    private let dependencias: FlujosDeNavegacionDependencias
    
    //TODO: ir a primera vista
    //private weak var loginVC: .....
    
    
    init(navigationController: UINavigationController, dependencias: FlujosDeNavegacionDependencias) {
        self.navigationController = navigationController
        self.dependencias = dependencias
    }
}
