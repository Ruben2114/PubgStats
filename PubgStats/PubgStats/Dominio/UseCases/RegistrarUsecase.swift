//
//  RegistrarUsecase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 7/3/23.
//

import Foundation

protocol RegistrarUsecase {
    func ejecutar(
        valorSocilitado: BuscarUsuarioUseCaseValor,
        cacheado: @escaping (Cuenta) -> Void,
        finalizacion: @escaping (Result<Cuenta, Error>) -> Void
    ) -> Cancelable?
}
final class RegistroCuentaPorDefectoUseCas: RegistrarUsecase {
    private let cuentaRepositorio: CuentaRepositorio
    private let cuentaconsultaRepositorio: CuentaconsultaRepositorio
    
    init(cuentaRepositorio: CuentaRepositorio, cuentaconsultaRepositorio: CuentaconsultaRepositorio) {
        self.cuentaRepositorio = cuentaRepositorio
        self.cuentaconsultaRepositorio = cuentaconsultaRepositorio
    }
    func ejecutar(valorSocilitado: BuscarUsuarioUseCaseValor, cacheado: @escaping (Cuenta) -> Void, finalizacion: @escaping (Result<Cuenta, Error>) -> Void) -> Cancelable? {
        return cuentaRepositorio.buscarListaCuentas(consulta: valorSocilitado.consulta, nombre: valorSocilitado.nombre, cacheado: cacheado, finalizacion: { resultado in
            if case .success = resultado {
                self.cuentaconsultaRepositorio.guardarConsulta(query: valorSocilitado.consulta) { _ in }
            }
            finalizacion(resultado)
        })
    }
}
struct BuscarUsuarioUseCaseValor {
    let consulta: Consulta
    let nombre: String
}
