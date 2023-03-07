//
//  CuentaRepositorio.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 7/3/23.
//

import Foundation

protocol CuentaRepositorio {
    @discardableResult
    func agregarCuenta(
        nombre: String,
        contrasena: String,
        finalizacion: @escaping (Result<Cuenta, Error>) -> Void
    ) -> Cancelable?
}
