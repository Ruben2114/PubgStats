//
//  Cuenta.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 7/3/23.
//

import Foundation

struct Cuenta: Equatable, Identifiable {
    let id: String //hacerlo que aumente solo
    let nombre: String
    let contrasena: String
    let DiaDeCreacion: Date //automaticamente por el dia (solo d/m/a)
}
