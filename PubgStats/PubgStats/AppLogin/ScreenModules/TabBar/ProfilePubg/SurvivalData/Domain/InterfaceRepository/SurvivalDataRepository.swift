//
//  SurvivalDataRepository.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

protocol SurvivalDataRepository {
    func getSurvival(for sessionUser: ProfileEntity, type: NavigationStats) -> Survival?
}
