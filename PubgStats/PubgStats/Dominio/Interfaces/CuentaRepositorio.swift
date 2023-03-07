//
//  CuentaRepositorio.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 7/3/23.
//

import Foundation

protocol CuentaRepositorio {
    @discardableResult
    func buscarListaCuentas(
        consulta: Consulta,
        nombre: String,
        cacheado: @escaping (Cuenta) -> Void,
        finalizacion: @escaping (Result<Cuenta, Error>) -> Void
    ) -> Cancelable?
}
