//
//  GamesModesDataRepository.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

protocol GamesModesDataRepository {
    func getGamesModes(for sessionUser: ProfileEntity, type: NavigationStats) -> [GamesModes]?
}
