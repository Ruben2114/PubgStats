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
    var itemCellStats: [ItemCellStats] = [ItemCellStats.dataKill, ItemCellStats.dataWeapon, ItemCellStats.dataSurvival, ItemCellStats.dataGamesModes]
    var allDifferentValuesRadarChart: [CGFloat] = []
    var allDifferentTitleRadarChart: [String] = []
    var valuesRadarChart: [CGFloat] = [0,0,0,0,0]
    var titleRadarChart: [String] = ["","","","",""]
    var valueWin: CGFloat = 0
    init(dependencies: StatsGeneralDependency) {
        self.dependencies = dependencies
        self.coordinator = dependencies.resolve()
    }
    func viewDidLoad() {
        
    }

    func reload(){
        let userDefaults = UserDefaults.standard
        userDefaults.set(false, forKey: "reload")
        //TODO: hacer las llamadas sin ser cacheadas
    }
    private func searchData() -> [String?] {
        guard let type = coordinator?.type else {return [nil]}
        if type == .favourite{
            return []
            //[sessionUser.accountFavourite, sessionUser.nameFavourite, sessionUser.platformFavourite]
        } else {
            return []
            //[sessionUser.account, sessionUser.player, sessionUser.platform]
        }
    }
    
    func createDataGeneralPlayer(data: GamesModes) {
//        let percentage = data.wonTotal * 100 / data.gamesPlayed
//        let dataLabel = DataLabel(winsLabel: "\(data.wonTotal)",
//                                  timePlayedLabel: "\(data.timePlayed ?? "0")",
//                                  killsLabel: "\(data.killsTotal)",
//                                  assistsLabel: "\(data.assistsTotal)",
//                                  knocksLabel: "300",
//                                  bestRankedLabel: "\(data.bestRankPoint)",
//                                  gamesPlayedLabel: "\(data.gamesPlayed)",
//                                  dataLabelComplement: nil)
//        var dataPlayer = DataGeneralPlayerRepresentable(percentage: Int(percentage), modeLabel: "General", dataLabel: dataLabel)
//        dataPlayer.gamesLabel += "\(data.gamesPlayed)"
//        dataPlayer.topLabel += "\(data.top10S)"
//        return dataPlayer
    }
    
    func dataRadarChart(){
//        guard let type = coordinator?.type else {return}
//        let gamesModesData = statsGeneralDataUseCase.getGamesModes(type: type)
//        guard let data = gamesModesData else {return}
//
//        let losseTotal = data.compactMap{$0.losses}.reduce(0,+)
//        let headshotKillsTotal = data.compactMap{$0.headshotKills}.reduce(0,+)
//        let top10STotal = data.compactMap{$0.top10S}.reduce(0,+)
//
//        let win = PlayerStats.wins(value: CGFloat(data[0].wonTotal * 100 / data[0].gamesPlayed), average: 0.25)
//        let kills = PlayerStats.kills(value: CGFloat(data[0].killsTotal / data[0].gamesPlayed), average: 0.30)
//        let losses = PlayerStats.losses(value: CGFloat(losseTotal * 100 / data[0].gamesPlayed), average: 1.0)
//        let headshotKills = PlayerStats.headshotKills(value: CGFloat(headshotKillsTotal * 100 / data[0].killsTotal), average: 1.0)
//        let top10 = PlayerStats.top10(value: CGFloat(top10STotal * 100 / data[0].gamesPlayed), average: 1.0)
//
//        //TODO: valores que puedes ver en la grafica
//        let item = [win, losses, headshotKills, kills, top10]
//        let values = item.map{ $0.value()}
//        valuesRadarChart = values
//        let title = item.map { $0.title()}
//        titleRadarChart = title
//
//        //TODO: todos los valores, poner mas y asi se ve la diferencia
//        let allItem = [win, losses, headshotKills, kills, top10]
//        let allValues = allItem.map{ $0.value()}
//        let allTitle = allItem.map { $0.title()}
//        allDifferentValuesRadarChart = allValues
//        allDifferentTitleRadarChart = allTitle
    }
    
    func backButton() {
        coordinator?.dismiss()
    }
    func goKillsData() {
    }
    func goWeapons() {
    }
    func goSurvival() {
    }
    func goGamesModes() {
        
    }
}
