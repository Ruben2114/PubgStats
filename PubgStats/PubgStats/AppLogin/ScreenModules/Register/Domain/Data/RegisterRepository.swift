//
//  RegisterRepository.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/3/23.
//

protocol RegisterRepository {
    func saveProfileModel (name: String, password: String, email: String) -> Bool
}
