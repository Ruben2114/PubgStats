//
//  ForgotRepository.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 3/4/23.
//

protocol ForgotRepository {
    func check(name: String, email: String) -> Bool
}
