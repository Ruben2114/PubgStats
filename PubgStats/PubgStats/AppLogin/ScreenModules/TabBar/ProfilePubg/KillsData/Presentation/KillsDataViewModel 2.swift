//
//  KillsDataViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

final class KillsDataViewModel {
    private weak var coordinator: KillsDataCoordinator?
    private let dependencies: KillsDataDependency
    private var dataKills: [String] = []
    var dataKillsDict: [String: Int] = [:]
    init(dependencies: KillsDataDependency) {
        self.dependencies = dependencies
        self.coordinator = dependencies.resolve()
    }
    func fetchDataKills() {
        let sessionUser: ProfileEntity = dependencies.external.resolve()
        guard let gameModes = sessionUser.gameModes?.first else { return }
        reflectStats(gameModes.squad, gameModes.squadFpp, gameModes.duo, gameModes.duoFpp, gameModes.solo, gameModes.soloFpp)
        for item in dataKills {
            let components = item.components(separatedBy: ": ")
            guard let value = Int(components[1]) else {
                continue
            }
            dataKillsDict[components[0]] = dataKillsDict[components[0], default: 0] + value
        }
    }
    func reflectStats(_ stats: Any...) {
        for stat in stats {
            for (name, value) in Mirror(reflecting: stat).children {
                dataKills.append("\(name?.uppercased() ?? ""): \(value)")
            }
        }
    }
    func backButton() {
        coordinator?.dismiss()
    }
}
