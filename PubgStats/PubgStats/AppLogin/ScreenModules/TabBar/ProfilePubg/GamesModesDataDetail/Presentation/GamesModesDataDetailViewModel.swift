//
//  GamesModesDataDetailViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

final class GamesModesDataDetailViewModel {
    private weak var coordinator: GamesModesDataDetailCoordinator?
    var dataGamesModes: [(String, Any)] = []
    init(dependencies: GamesModesDataDetailDependency) {
        self.coordinator = dependencies.resolve()
    }
    func fetchDataGamesModesDetail(){
//        if let modes = data {
//            for mode in modes {
//                if sessionUser.gameMode == mode.mode {
//                    let excludedKeys = ["bestRankPoint", "gamesPlayed", "killsTotal", "timePlayed", "assistsTotal", "wonTotal","mode", "maxKillStreaks"]
//                    let keyValues = mode.entity.attributesByName.filter { !excludedKeys.contains($0.key) }.map { ($0.key, mode.value(forKey: $0.key) ?? "") }
//                    let keyMap = [
//                        "assists": "Asistencias",
//                        "rideDistance": "Distancia recorrida en vehículo",
//                        "mostSurvivalTime": "Tiempo de supervivencia más largo",
//                        "roadKills": "Muertes por atropello",
//                        "kills": "Muertes",
//                        "swimDistance": "Distancia nadando",
//                        "days": "Días",
//                        "dBNOS": "Derribados",
//                        "boosts": "Potenciadores",
//                        "dailyKills": "Muertes diarias",
//                        "revives": "Reanimaciones",
//                        "heals": "Curaciones",
//                        "losses": "Derrotas",
//                        "roundMostKills": "Mayor muertes en una ronda",
//                        "vehicleDestroys": "Vehículos destruidos",
//                        "roundsPlayed": "Rondas jugadas",
//                        "weeklyWINS": "Victorias semanales",
//                        "top10S": "Top 10s",
//                        "wins": "Victorias",
//                        "suicides": "Suicidios",
//                        "dailyWINS": "Victorias diarias",
//                        "longestKill": "Mayor distancia de muerte",
//                        "timeSurvived": "Tiempo de supervivencia",
//                        "damageDealt": "Daño infligido",
//                        "headshotKills": "Muertes con disparo en la cabeza",
//                        "teamKills": "Muertes de equipo",
//                        "weaponsAcquired": "Armas adquiridas",
//                        "walkDistance": "Distancia caminada",
//                        "weeklyKills": "Muertes semanales",
//                    ]
//                    var newDict: [(String, Any)] = []
//                    for (oldKey, value) in keyValues {
//                        if let newKey = keyMap.first(where: { $0.0 == oldKey })?.1 {
//                            newDict.append((newKey, value))
//                        } else {
//                            newDict.append((oldKey, value))
//                        }
//                    }
//                    for i in 0..<newDict.count {
//                        if let value = newDict[i].1 as? Double {
//                            newDict[i].1 = Int(value)
//                        }
//                    }
//                    dataGamesModes = newDict
//                }
//            }
//        }
    }
    func backButton() {
        coordinator?.dismiss()
    }
}

