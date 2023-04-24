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
                let excludedKeys = ["bestRankPoint", "gamesPlayed", "timePlayed", "assistsTotal", "boosts", "wonTotal", "mode", "losses", "mostSurvivalTime","rideDistance" ,"roundsPlayed" ,"swimDistance" ,"timeSurvived","top10S","walkDistance","weaponsAcquired","weeklyWINS","dailyWINS","wins","damageDealt","days", "longestKill", "maxKillStreaks", "dailyKills","weeklyKills", "killsTotal","roundMostKills", "teamKills"]
                let keyValues = mode.entity.attributesByName.filter { !excludedKeys.contains($0.key) }.map { ($0.key, mode.value(forKey: $0.key) ?? "") }
                let keyMap = [("roadKills", "Atropellos"),
                              ("suicides", "Suicidios"),
                              ("dBNOS", "Derribados"),
                              ("revives", "Reanimaciones"),
                              ("assists", "Asistencias"),
                              ("kills", "Muertes"),
                              ("vehicleDestroys", "Destrucciones de vehículos"),
                              ("headshotKills", "Muertes por disparos a la cabeza"),
                              ("heals", "Curaciones")]
                var newDict: [(String, Any)] = []
                for (oldKey, value) in keyValues {
                    if let newKey = keyMap.first(where: { $0.0 == oldKey })?.1 {
                        newDict.append((newKey, value))
                    } else {
                        newDict.append((oldKey, value))
                    }
                }
                dataGamesModes.append(contentsOf: newDict)
            }
            let combinedDataGamesModes = dataGamesModes.reduce(into: [String: Int]()) { result, element in
                if let previousValue = result[element.0] {
                    result[element.0] = previousValue + (element.1 as? Int ?? 0)
                } else {
                    result[element.0] = element.1 as? Int ?? 0
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
