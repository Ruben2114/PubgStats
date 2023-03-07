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
        nombre: String,
        contrasena: String,
        finalizacion: @escaping (Result<[Cuenta], Error>) -> Void
    ) -> Cancelable?
    
    func guardarConsulta(
        query: Registro,
        finalizacion: @escaping (Result<Registro, Error>) -> Void
    )
}
