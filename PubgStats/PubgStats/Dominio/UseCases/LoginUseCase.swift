//
//  LoginUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 7/3/23.
//

import Foundation
final class LoginUseCase: UseCase{
    struct BuscarUsuario {
        let nombre: String
        let contrasena: String
    }
    typealias Usuario = (Result<[Cuenta], Error>)
    
    private let buscarUsuario: BuscarUsuario
    private let finalizacion: (Usuario) -> Void
    private let cuentaconsultaRepositorio: CuentaconsultaRepositorio
    
    init(buscarUsuario: BuscarUsuario, finalizacion: @escaping (Usuario) -> Void, cuentaconsultaRepositorio: CuentaconsultaRepositorio) {
        self.buscarUsuario = buscarUsuario
        self.finalizacion = finalizacion
        self.cuentaconsultaRepositorio = cuentaconsultaRepositorio
    }
    func empezar() -> Cancelable? {
        cuentaconsultaRepositorio.buscarListaCuentas( consulta: Registro(nombre: buscarUsuario.nombre, contrasena: buscarUsuario.contrasena), finalizacion: finalizacion)
        return nil
    }
}
