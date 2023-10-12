//
//  KillsDataRepository.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

protocol KillsDataRepository {
    func getGamesModes(type: NavigationStats) -> [GamesModes]?
}
