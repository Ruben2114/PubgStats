//
//  LoginDataUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 14/3/23.
//

protocol LoginDataUseCase {
    func check(name: String, password: String) -> Bool
}

struct LoginDataUseCaseImp: LoginDataUseCase {
    private(set) var loginRepository: LoginRepository

    func check(name: String, password: String) -> Bool {
        loginRepository.checkName(name: name, password: password)
    }
}
