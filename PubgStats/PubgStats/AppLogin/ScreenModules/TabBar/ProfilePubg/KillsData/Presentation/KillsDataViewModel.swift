//
//  KillsDataViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

final class KillsDataViewModel {
    private weak var coordinator: KillsDataCoordinator?
    private let dependencies: KillsDataDependency
    var dataKills: [String] = []
    private let sessionUser: ProfileEntity
    private let killsDataUseCase: KillsDataUseCase
    init(dependencies: KillsDataDependency) {
        self.dependencies = dependencies
        self.coordinator = dependencies.resolve()
        self.sessionUser = dependencies.external.resolve()
        self.killsDataUseCase = dependencies.resolve()
    }
    
    func getGamesModes(for sessionUser: ProfileEntity) -> [GamesModes]?{
        guard let type = coordinator?.type else {return nil}
        let killsData = killsDataUseCase.getGamesModes(for: sessionUser, type: type)
        return killsData
    }
    func fetchDataKills() {
        let gameModes = getGamesModes(for: sessionUser)
        if let modes = gameModes {
            var dataGamesModes: [(String, Any)] = []
            for mode in modes {
                let excludedKeys = ["bestRankPoint", "gamesPlayed", "timePlayed", "top10STotal", "wonTotal","mode","losses","mostSurvivalTime","longestTimeSurvived","rankPoints","rankPointsTitle","rideDistance","roundsPlayed","swimDistance","timeSurvived","top10S","walkDistance","weaponsAcquired","weeklyWINS","dailyWINS","winPoints","wins","damageDealt","days"]
                let keyValues = mode.entity.attributesByName.filter { !excludedKeys.contains($0.key) }.map { ($0.key, mode.value(forKey: $0.key) ?? "") }
                dataGamesModes.append(contentsOf: keyValues)
            }
            let combinedDataGamesModes = dataGamesModes.reduce(into: [:]) { result, element in
                if let previousValue = result[element.0] as? Int, let currentValue = element.1 as? Int {
                    result[element.0] = previousValue + currentValue
                } else {
                    result[element.0] = element.1
                }
            }
            let dataArray = combinedDataGamesModes.map { key, value in "\(key): \(value)" }
            dataKills = dataArray
        }
    }
    func backButton() {
        coordinator?.dismiss()
    }
}
