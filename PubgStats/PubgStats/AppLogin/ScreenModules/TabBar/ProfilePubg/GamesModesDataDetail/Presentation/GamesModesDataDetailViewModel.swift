//
//  GamesModesDataDetailViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

final class GamesModesDataDetailViewModel {
    private weak var coordinator: GamesModesDataDetailCoordinator?
    private let sessionUser: ProfileEntity
    var dataGamesModes: [(String, Any)] = []
    init(dependencies: GamesModesDataDetailDependency) {
        self.coordinator = dependencies.resolve()
        self.sessionUser = dependencies.external.resolve()
    }
    func fetchDataGamesModesDetail(){
        let data = sessionUser.gameModesDetail
        if let modes = data {
            for mode in modes {
                if sessionUser.gameMode == mode.mode {
                    let excludedKeys = ["bestRankPoint", "gamesPlayed", "killsTotal", "timePlayed", "top10STotal", "wonTotal","mode"]
                    let keyValues = mode.entity.attributesByName.filter { !excludedKeys.contains($0.key) }.map { ($0.key, mode.value(forKey: $0.key) ?? "") }
                    dataGamesModes = keyValues
                }
            }
        }
    }
    func backButton() {
        coordinator?.dismiss()
    }
}
