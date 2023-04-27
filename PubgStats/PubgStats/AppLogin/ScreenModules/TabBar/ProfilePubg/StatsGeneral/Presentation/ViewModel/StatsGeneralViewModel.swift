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
    var valuesRadarChart: [CGFloat] = []
    var titleRadarChart: [String] = []
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
        allDataRadarChart()
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
    func allDataRadarChart(){
        guard let type = coordinator?.type else {return}
        let gamesModesData = statsGeneralDataUseCase.getGamesModes(for: sessionUser, type: type)
        guard let gamesModes = gamesModesData else {return}
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
        //la primera funcion coge los datos y la segunda los trata, dividir en dos cuando ponga el usecase
        
        let winsAverageData = 0.25
        let killsAverageData = 0.30
        let lossesAverageData = 1.0
        let headshotKillsAverageData = 1.0
        let top10AverageData = 1.0
        
        let winsValue = (combinedDataGamesModes["wins"] ?? 0) * 100 / (combinedDataGamesModes["roundsPlayed"] ?? 0)
        let killsValue = (combinedDataGamesModes["kills"] ?? 0) / (combinedDataGamesModes["roundsPlayed"] ?? 0)
        let lossesValue = (combinedDataGamesModes["losses"] ?? 0) * 100 / (combinedDataGamesModes["roundsPlayed"] ?? 0)
        let headshotKillsValue = (combinedDataGamesModes["headshotKills"] ?? 0) * 100 / (combinedDataGamesModes["kills"] ?? 0)
        let top10Value = (combinedDataGamesModes["top10S"] ?? 0) * 100 / (combinedDataGamesModes["roundsPlayed"] ?? 0)
        
        let win = PlayerStats2.wins(title: "playerStatsV".localize() + "\(String(format: "%.1f", winsValue))%", value: CGFloat(max(0,min(winsValue / 100 / winsAverageData, 1.0))))
        let kills = PlayerStats2.kills(title: "playerStatsK".localize() + "\(String(format: "%.1f", killsValue))", value: CGFloat(max(0,min(killsValue / 100 / killsAverageData, 1.0))))
        let losses = PlayerStats2.losses(title: "playerStatsD".localize() + "\(String(format: "%.1f", lossesValue))%", value: CGFloat(max(0,min(lossesValue / 100 / lossesAverageData, 1.0))))
        let headshotKills = PlayerStats2.headshotKills(title: "playerStatsMD".localize() + "\(String(format: "%.1f", headshotKillsValue))%", value: CGFloat(max(0,min(headshotKillsValue / 100 / headshotKillsAverageData, 1.0))))
        let top10 = PlayerStats2.top10(title: "playerStatsT".localize() + "\(String(format: "%.1f", top10Value))%", value: CGFloat(max(0,min(top10Value / 100 / top10AverageData, 1.0))))
        
        let item = [win,losses,headshotKills,kills,top10]
        let values = item.map{ $0.value()}
        valuesRadarChart = values
        let title = item.map { $0.title()}
        titleRadarChart = title
        valueWin = win.value()
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
