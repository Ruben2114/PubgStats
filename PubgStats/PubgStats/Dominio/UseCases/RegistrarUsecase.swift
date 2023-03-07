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
    func ejecutar(valorSocilitado: BuscarUsuarioUseCaseValor, finalizacion: @escaping (Result<Cuenta, Error>) -> Void) -> Cancelable? {
        return cuentaRepositorio.agregarCuenta(nombre: valorSocilitado.nombre, contrasena: valorSocilitado.contrasena, finalizacion: { resultado in
            if case .success = resultado {
                self.cuentaconsultaRepositorio.guardarConsulta(query: Registro(nombre: valorSocilitado.nombre, contrasena: valorSocilitado.contrasena)) {_ in}
            }
            finalizacion(resultado)
        })
    }
}
struct BuscarUsuarioUseCaseValor {
    let nombre: String
    let contrasena: String
}
