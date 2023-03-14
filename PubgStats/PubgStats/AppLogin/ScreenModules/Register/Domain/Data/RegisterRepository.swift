//
//  RegisterRepository.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 13/3/23.
//

protocol RegisterRepository {
    func saveProfileModel (profile: Profile)
    func checkName(name: String) -> Bool
}
