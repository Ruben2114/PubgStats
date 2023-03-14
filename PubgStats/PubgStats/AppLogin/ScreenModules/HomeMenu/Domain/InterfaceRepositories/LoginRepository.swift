//
//  LoginRepository.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 14/3/23.
//

protocol LoginRepository {
    func getProfile (name: String, password: String) async throws -> Profile?
}

