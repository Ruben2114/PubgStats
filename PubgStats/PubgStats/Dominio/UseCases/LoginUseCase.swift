//
//  LoginUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 7/3/23.
//

import Foundation
final class LoginUseCase: UseCase{
    struct UsuarioGuardado {
        let nombre: String
    }
    typealias Usuario = (Result<[Consulta], Error>)
    
    private let usuarioGuardado: UsuarioGuardado
    private let finalizacion: (Usuario) -> Void
    private let cuentaconsultaRepositorio: CuentaconsultaRepositorio
    
    init(usuarioGuardado: UsuarioGuardado, finalizacion: @escaping (Usuario) -> Void, cuentaconsultaRepositorio: CuentaconsultaRepositorio) {
        self.usuarioGuardado = usuarioGuardado
        self.finalizacion = finalizacion
        self.cuentaconsultaRepositorio = cuentaconsultaRepositorio
    }
    func empezar() -> Cancelable? {
        cuentaconsultaRepositorio.buscarConsultasGuardadas(nombre: usuarioGuardado.nombre, finalizacion: finalizacion)
        return nil
    }
}
