//
//  LoginDataUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 14/3/23.
//

protocol LoginDataUseCase {
    func execute() async throws -> Profile?
}

struct LoginDataUseCaseImp: LoginDataUseCase {
    private(set) var loginRepository: LoginRepository
    private(set) var name: String
    private(set) var password: String

    func execute() async throws -> Profile? {
        try await loginRepository.getProfile(name: name, password: password)
    }
}
