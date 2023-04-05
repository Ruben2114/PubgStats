//
//  ForgotDataUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 3/4/23.
//

protocol ForgotDataUseCase {
    func check(name: String, email: String) -> Bool
}

struct ForgotDataUseCaseImp: ForgotDataUseCase {
    private let forgotRepository: ForgotRepository
    init(dependencies: ForgotDependency) {
        self.forgotRepository = dependencies.resolve()
    }
    func check(name: String, email: String) -> Bool {
        forgotRepository.check(name: name, email: email)
    }
}
