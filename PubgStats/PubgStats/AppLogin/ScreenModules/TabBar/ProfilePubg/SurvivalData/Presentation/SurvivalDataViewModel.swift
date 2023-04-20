//
//  SurvivalDataViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/4/23.
//

final class SurvivalDataViewModel {
    private weak var coordinator: SurvivalDataCoordinator?
    private let dependencies: SurvivalDataDependency
    private let sessionUser: ProfileEntity
    private let survivalDataUseCase: SurvivalDataUseCase
    var content: [(String, Any)] = []
    init(dependencies: SurvivalDataDependency) {
        self.sessionUser = dependencies.external.resolve()
        self.survivalDataUseCase = dependencies.resolve()
        self.dependencies = dependencies
        self.coordinator = dependencies.resolve()
    }
    
    func getSurvival(for sessionUser: ProfileEntity) -> Survival?{
        guard let type = coordinator?.type else {return nil}
        let survivalData = survivalDataUseCase.getSurvival(for: sessionUser, type: type)
        return survivalData
    }
    func fetchDataSurvival() {
        let survivalData = getSurvival(for: sessionUser)
        if let survival = survivalData {
            let excludedKeys = ["xp","level","position","timeSurvived"]
            let keyValues = survival.entity.attributesByName.filter { !excludedKeys.contains($0.key) }.map { ($0.key, survival.value(forKey: $0.key) ?? "") }
            let keyMap = [("airDropsCalled", "AirDrops llamados"),
                          ("hotDropLandings", "Aterrizajes en zonas conflictivas"),
                          ("top10", "Top 10"),
                          ("damageTaken", "Daño recibido"),
                          ("distanceOnFoot", "Distancia andando"),
                          ("distanceBySwimming", "Distancia nadando"),
                          ("distanceTotal", "Distancia total"),
                          ("uniqueItemsLooted", " Objetos únicos saqueados"),
                          ("totalMatchesPlayed", "Partidas jugadas"),
                          ("teammatesRevived", "Compañeros revividos"),
                          ("damageDealt", "Daño infligido"),
                          ("enemyCratesLooted", "Cajas enemigas saqueadas"),
                          ("healed", "Curaciones"),
                          ("distanceByVehicle", "Distancia en vehiculo"),
                          ("throwablesThrown", "Lanzables arrojados"),
                          ("revived", "Revivido")]
            
            var newDict: [(String, Any)] = []
            for (oldKey, value) in keyValues {
                if let newKey = keyMap.first(where: { $0.0 == oldKey })?.1 {
                    newDict.append((newKey, value))
                } else {
                    newDict.append((oldKey, value))
                }
            }
            content = newDict
            
        }
    }
    func backButton() {
        coordinator?.dismiss()
    }
}
