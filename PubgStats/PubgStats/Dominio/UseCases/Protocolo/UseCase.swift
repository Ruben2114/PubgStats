//
//  UseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 7/3/23.
//

import Foundation
//TODO: entender esta funcion y si me vale para mi
protocol UseCase {
    @discardableResult
    func empezar() -> Cancelable?
}
