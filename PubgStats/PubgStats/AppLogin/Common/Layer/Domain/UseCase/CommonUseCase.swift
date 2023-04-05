//
//  CommonUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 4/4/23.
//

protocol CommonUseCase {
    func check(_ value: String?, type: String) -> Bool
    var commonRepository: CommonRepository { get }
}

extension CommonUseCase {
    func check(_ value: String?, type: String) -> Bool {
        guard let value = value else { return false }
        if type == "name" {
            return commonRepository.checkName(name: value)
        } else if type == "email" {
            return commonRepository.checkEmail(email: value)
        }
        return false
    }
}
