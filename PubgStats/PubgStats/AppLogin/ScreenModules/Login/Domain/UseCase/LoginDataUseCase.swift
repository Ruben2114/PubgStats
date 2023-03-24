//
//  LoginDataUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 14/3/23.
//

protocol LoginDataUseCase {
    func check(sessionUser: ProfileEntity, name: String, password: String) -> Bool
}

struct LoginDataUseCaseImp: LoginDataUseCase {
    private(set) var loginRepository: LoginRepository

    func check(sessionUser: ProfileEntity, name: String, password: String) -> Bool {
        loginRepository.checkName(sessionUser: sessionUser, name: name, password: password)
    }
}
