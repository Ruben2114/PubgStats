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
            for mode in modes {  //longestTimeSurvived
                if sessionUser.gameMode == mode.mode {
                    let excludedKeys = ["bestRankPoint", "gamesPlayed", "killsTotal", "timePlayed", "top10STotal", "wonTotal","mode","rankPointsTitle", "maxKillStreaks"]
                    let keyValues = mode.entity.attributesByName.filter { !excludedKeys.contains($0.key) }.map { ($0.key, mode.value(forKey: $0.key) ?? "") }
                    let keyMap = [
                        "assists": "Asistencias",
                        "rideDistance": "Distancia recorrida en vehículo",
                        "mostSurvivalTime": "Tiempo de supervivencia más largo",
                        "roadKills": "Muertes por atropello",
                        "kills": "Muertes",
                        "swimDistance": "Distancia nadando",
                        "days": "Días",
                        "dBNOS": "Derribados",
                        "boosts": "Potenciadores",
                        "dailyKills": "Muertes diarias",
                        "revives": "Reanimaciones",
                        "heals": "Curaciones",
                        "losses": "Derrotas",
                        "rankPoints": "Puntos de rango",
                        "roundMostKills": "Mayor muertes en una ronda",
                        "vehicleDestroys": "Vehículos destruidos",
                        "roundsPlayed": "Rondas jugadas",
                        "weeklyWINS": "Victorias semanales",
                        "top10S": "Top 10s",
                        "wins": "Victorias",
                        "suicides": "Suicidios",
                        "dailyWINS": "Victorias diarias",
                        "longestKill": "Muertes a la mayor distancia",
                        "timeSurvived": "Tiempo de supervivencia",
                        "damageDealt": "Daño infligido",
                        "headshotKills": "Muertes con disparo en la cabeza",
                        "teamKills": "Muertes de equipo",
                        "weaponsAcquired": "Armas adquiridas",
                        "walkDistance": "Distancia caminada",
                        "weeklyKills": "Muertes semanales",
                    ]
                    var newDict: [(String, Any)] = []
                    for (oldKey, value) in keyValues {
                        if let newKey = keyMap.first(where: { $0.0 == oldKey })?.1 {
                            newDict.append((newKey, value))
                        } else {
                            newDict.append((oldKey, value))
                        }
                    }
                    for i in 0..<newDict.count {
                        if let value = newDict[i].1 as? Double {
                            newDict[i].1 = Int(value)
                        }
                    }

                    print(newDict)
                    
                    dataGamesModes = newDict
                }
            }
        }
    }
    func backButton() {
        coordinator?.dismiss()
    }
}
