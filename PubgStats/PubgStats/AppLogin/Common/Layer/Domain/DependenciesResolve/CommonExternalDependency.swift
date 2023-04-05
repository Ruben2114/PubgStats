//
//  CommonExternalDependency.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 5/4/23.
//

protocol CommonExternalDependency {
    func resolve() -> AppDependencies
    func resolve() -> LocalDataProfileService
}

