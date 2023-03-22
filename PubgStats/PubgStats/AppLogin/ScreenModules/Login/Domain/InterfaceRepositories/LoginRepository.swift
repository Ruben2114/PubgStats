//
//  LoginRepository.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 14/3/23.
//

protocol LoginRepository {
    func checkName(name: String, password: String) -> Bool
}

