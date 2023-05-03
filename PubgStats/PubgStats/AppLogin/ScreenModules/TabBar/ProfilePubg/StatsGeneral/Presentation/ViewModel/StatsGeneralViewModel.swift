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
    var allDifferentValuesRadarChart: [CGFloat] = []
    var allDifferentTitleRadarChart: [String] = []
    var valuesRadarChart: [CGFloat] = [0,0,0,0,0]
    var titleRadarChart: [String] = ["","","","",""]
    var valueWin: CGFloat = 0
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
        dataRadarChart()
        state.send(.getSurvival(model: survivalData))
        state.send(.getGamesMode(model: gamesModesData))
        state.send(.getItemRadarChar(title: titleRadarChart, values: valuesRadarChart))
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
    private func searchData() -> [String?] {
        guard let type = coordinator?.type else {return [nil]}
        if type == .favourite{
            return [sessionUser.accountFavourite, sessionUser.nameFavourite]
        } else {
            return [sessionUser.account, sessionUser.player]
        }
    }
    
    func dataRadarChart(){
        let data = getDataRadarChart()
               
        let win = PlayerStats.wins(value: (data["wins"] ?? 0) * 100 / (data["roundsPlayed"] ?? 0), average: 0.25)
        let kills = PlayerStats.kills(value: (data["kills"] ?? 0) / (data["roundsPlayed"] ?? 0), average: 0.30)
        let losses = PlayerStats.losses(value: (data["losses"] ?? 0) * 100 / (data["roundsPlayed"] ?? 0), average: 1.0)
        let headshotKills = PlayerStats.headshotKills(value: (data["headshotKills"] ?? 0) * 100 / (data["kills"] ?? 0), average: 1.0)
        let top10 = PlayerStats.top10(value: (data["top10S"] ?? 0) * 100 / (data["roundsPlayed"] ?? 0), average: 1.0)
        
        //TODO: valores que puedes ver en la grafica
        let item = [win, losses, headshotKills, kills, top10]
        let values = item.map{ $0.value()}
        valuesRadarChart = values
        let title = item.map { $0.title()}
        titleRadarChart = title
        
        //TODO: todos los valores, poner mas y asi se ve la diferencia
        let allItem = [win, losses, headshotKills, kills, top10]
        let allValues = allItem.map{ $0.value()}
        let allTitle = allItem.map { $0.title()}
        allDifferentValuesRadarChart = allValues
        allDifferentTitleRadarChart = allTitle
    }
    private func getDataRadarChart() -> [String : Double]{
        guard let type = coordinator?.type else {return [:]}
        let gamesModesData = statsGeneralDataUseCase.getGamesModes(for: sessionUser, type: type)
        guard let gamesModes = gamesModesData else {return [:]}
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
        return combinedDataGamesModes
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
