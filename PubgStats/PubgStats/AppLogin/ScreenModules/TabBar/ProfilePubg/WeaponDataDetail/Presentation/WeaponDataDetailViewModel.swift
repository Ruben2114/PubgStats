//
//  WeaponDataDetailViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 28/3/23.
//

import Foundation

final class WeaponDataDetailViewModel {
    private weak var coordinator: WeaponDataDetailCoordinator?
    private let sessionUser: ProfileEntity
    private let weaponDataDetailUseCase: WeaponDataDetailUseCase
    private let dependencies: WeaponDataDetailDependency
    var dataWeaponDetail: [(String, Any)] = []
    init(dependencies: WeaponDataDetailDependency) {
        self.sessionUser = dependencies.external.resolve()
        self.coordinator = dependencies.resolve()
        self.weaponDataDetailUseCase = dependencies.resolve()
        self.dependencies = dependencies
    }
    func getDataWeaponDetail(for sessionUser: ProfileEntity) -> [Weapon]? {
        guard let type = coordinator?.type else {return nil}
        let weaponData = weaponDataDetailUseCase.getDataWeaponDetail(for: sessionUser, type: type)
        return weaponData
    }
    func fetchDataWeaponDetail() {
        let dataWeapon = getDataWeaponDetail(for: sessionUser)
        if let modes = dataWeapon {
            for mode in modes {
                if sessionUser.weapon == mode.name {
                    guard let modeData = mode.data else {return}
                    if let data = try? PropertyListSerialization.propertyList(from: modeData, options: [],format: nil) as? [String: Any]{
                        let keyMap = [
                        ("Tier Current", "Nivel"),
                        ("MostDamagePlayerInAGame", "Daño máximo en partida"),
                        ("MostHeadShotsInAGame", "Record disparos en la cabeza en partida"),
                        ("Level Current", "Nivel actual"),
                        ("DamagePlayer", "Daño realizado"),
                        ("Kills", "Muertes"),
                        ("HeadShots", "Disparos en la cabeza"),
                        ("LongestDefeat", "Mayor distancia derribado"),
                        ("LongRangeDefeats", "Número de derribados a larga distancia"),
                        ("Defeats", "Derribados"),
                        ("Groggies", "Aturdidos"),
                        ("MostKillsInAGame", "Record muertes en partida"),
                        ("XP Total", "Xp"),
                        ("MostDefeatsInAGame", "Mayor número de derribado en partida"),
                        ("MostGroggiesInAGame", "Record aturdidos en partida")]
                        var newDict: [(String, Any)] = []
                        for (oldKey, value) in data {
                            if let newKey = keyMap.first(where: { $0.0 == oldKey })?.1 {
                                newDict.append((newKey, value))
                            } else {
                                newDict.append((oldKey, value))
                            }
                        }
                        dataWeaponDetail = newDict
                    }
                }
            }
        }
    }
    func backButton() {
        coordinator?.dismiss()
    }
}
