//
//  CuentaconsultaRepositorio.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 7/3/23.
//

import Foundation

protocol CuentaconsultaRepositorio {
    func buscarConsultasGuardadas(
        nombre: String,
        finalizacion: @escaping (Result<[Consulta], Error>) -> Void
    )
    func guardarConsulta(
        query: Consulta,
        finalizacion: @escaping (Result<Consulta, Error>) -> Void
    )
}
