//
//  StatsGeneralViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

import Foundation
import Combine

final class StatsGeneralViewModel {
    var state = PassthroughSubject<OutputStats, Never>()
    private let dependencies: StatsGeneralDependency
    private weak var coordinator: StatsGeneralCoordinator?
    private let statsGeneralDataUseCase: StatsGeneralDataUseCase
    private let sessionUser: ProfileEntity
    var itemCellStats: [ItemCellStats] = [ItemCellStats.dataKill, ItemCellStats.dataWeapon, ItemCellStats.dataSurvival, ItemCellStats.dataGamesModes]
    init(dependencies: StatsGeneralDependency) {
        self.dependencies = dependencies
        self.coordinator = dependencies.resolve()
        self.sessionUser = dependencies.external.resolve()
        self.statsGeneralDataUseCase = dependencies.resolve()
    }
    func viewDidLoad() {
        state.send(.loading)
        guard let name = searchData()[1], !name.isEmpty else {return}
        state.send(.getName(model: name))
        guard let type = coordinator?.type else {return}
        let survivalData = statsGeneralDataUseCase.getSurvival(for: sessionUser, type: type)
        let gamesModesData = statsGeneralDataUseCase.getGamesModes(for: sessionUser, type: type)
        let userDefaults = UserDefaults.standard
        guard let lastUpdate = userDefaults.object(forKey: "lastUpdate") as? Date, Date().timeIntervalSince(lastUpdate) < 43200 else {
            reload()
            return
        }
        guard let _ = survivalData?.survival ?? survivalData?.survivalFav,
              let _ = gamesModesData?.first?.gamesMode ?? gamesModesData?.first?.gamesModeFav
        else {
            fetchData()
            return
        }
        state.send(.getSurvival(model: survivalData))
        state.send(.getGamesMode(model: gamesModesData))
        state.send(.success)
    }
    private func fetchData() {
        let dispatchGroup = DispatchGroup()
        guard let id = searchData()[0], !id.isEmpty else {return}
        guard let type = coordinator?.type else {return}
        dispatchGroup.enter()
        statsGeneralDataUseCase.executeSurvival(account: id) { [weak self] result in
            switch result {
            case .success(let survival):
                guard let user = self?.sessionUser else{return}
                self?.statsGeneralDataUseCase.saveSurvival(sessionUser: user, survivalData: [survival], type: type)
                dispatchGroup.leave()
            case .failure(_):
                self?.state.send(.fail(error: "fetchDataStatsError".localize()))
            }
        }
        dispatchGroup.enter()
        statsGeneralDataUseCase.executeGamesModes(account: id) { [weak self] result in
            switch result {
            case .success(let gamesMode):
                guard let user = self?.sessionUser else{return}
                self?.statsGeneralDataUseCase.saveGamesModeData(sessionUser: user, gamesModeData: gamesMode, type: type)
                dispatchGroup.leave()
            case .failure(_):
                self?.state.send(.fail(error: "fetchDataStatsError".localize()))
            }
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            let userDefaults = UserDefaults.standard
            userDefaults.set(Date(), forKey: "lastUpdate")
            self.viewDidLoad()
        }
    }
    func reload(){
        let userDefaults = UserDefaults.standard
        userDefaults.set(false, forKey: "reload")
        fetchData()
    }
    func searchData() -> [String?] {
        guard let type = coordinator?.type else {return [nil]}
        if type == .favourite{
            return [sessionUser.accountFavourite, sessionUser.nameFavourite]
        } else {
            return [sessionUser.account, sessionUser.player]
        }
    }
    
    let localData = LocalDataProfileServiceImp()
    func allDataRadarChart() -> PlayerStats? {
         guard let type = coordinator?.type else {return nil}
         let gamesModesData = statsGeneralDataUseCase.getGamesModes(for: sessionUser, type: type)
         guard let gamesModes = gamesModesData else {return nil}
         var dataGamesModes: [(String, Any)] = []
         for mode in gamesModes {
             let keyValues = mode.entity.attributesByName.map { ($0.key, mode.value(forKey: $0.key) ?? "") }
             
             dataGamesModes.append(contentsOf: keyValues)
         }
         let combinedDataGamesModes = dataGamesModes.reduce(into: [String: Double]()) { result, element in
             if let previousValue = result[element.0] {
                 result[element.0] = previousValue + (element.1 as? Double ?? 0.0)
             } else {
                 result[element.0] = element.1 as? Double ?? 0.0
             }
         }
        let playerStats = PlayerStats(
            wins: (combinedDataGamesModes["wins"] ?? 0) * 100 / (combinedDataGamesModes["roundsPlayed"] ?? 0),
            suicides: (combinedDataGamesModes["suicides"] ?? 0) * 100 / (combinedDataGamesModes["roundsPlayed"] ?? 0),
            losses: (combinedDataGamesModes["losses"] ?? 0) * 100 / (combinedDataGamesModes["roundsPlayed"] ?? 0),
            headshotKills: (combinedDataGamesModes["headshotKills"] ?? 0) * 100 / (combinedDataGamesModes["kills"] ?? 0),
            top10: (combinedDataGamesModes["top10S"] ?? 0) * 100 / (combinedDataGamesModes["roundsPlayed"] ?? 0)
        )
        return playerStats
    }
    func dataRadarChart() -> [String]{
        let dataPlayerStats = allDataRadarChart()
        guard let playerStats = dataPlayerStats else{ return []}
        let data = ["playerStatsV".localize() + "\n\(String(format: "%.1f", playerStats.wins))%",
                    "playerStatsT".localize() + "\n\(String(format: "%.0f", playerStats.top10))%",
                    "playerStatsMD" + "\n\(String(format: "%.0f", playerStats.headshotKills))%",
                    "playerStatsS" + "\n\(String(format: "%.0f", playerStats.suicides))%",
                    "playerStatsD" + "\n\(String(format: "%.1f", playerStats.losses))%"]
        return data
    }
    func valuesRadarChart() -> [CGFloat]{
        let dataPlayerStats = allDataRadarChart()
        //playerStats.wins * 100 / cota
        //declaar las constantes en playerstats
        //guardar en un array los valores y mostrarlos
        //4 es el porcertanje que le multiplico para que 25% de victorias sea el mejor dato
        guard let playerStats = dataPlayerStats else{ return []}
        let values = [CGFloat(max(0,min(playerStats.wins / 100 * 4, 1.0))),
                     CGFloat(playerStats.top10 / 100),
                     CGFloat(playerStats.headshotKills / 100),
                     CGFloat(playerStats.suicides / 100),
                     CGFloat(playerStats.losses / 100)]
        
        return values
    }
    
    func backButton() {
        coordinator?.dismiss()
    }
    func goKillsData() {
        coordinator?.performTransition(.goKillsData)
    }
    func goWeapons() {
        coordinator?.performTransition(.goWeapons)
    }
    func goSurvival() {
        coordinator?.performTransition(.goSurvival)
    }
    func goGamesModes() {
        coordinator?.performTransition(.goGamesModes)
    }
}
