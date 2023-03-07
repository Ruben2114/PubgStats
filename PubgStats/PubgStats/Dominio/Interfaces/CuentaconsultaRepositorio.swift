//
//  CuentaconsultaRepositorio.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 7/3/23.
//

import Foundation

protocol CuentaconsultaRepositorio {
    @discardableResult
    func buscarListaCuentas(
        consulta: Registro,
        finalizacion: @escaping (Result<[Cuenta], Error>) -> Void
    ) -> Cancelable?
    
    func guardarCuenta(
        consulta: Registro,
        finalizacion: @escaping (Result<Cuenta, Error>) -> Void
    )
}
