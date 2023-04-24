//
//  ItemCellStats.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 20/4/23.
//

import UIKit

enum ItemCellStats{
    case dataKill
    case dataWeapon
    case dataSurvival
    case dataGamesModes
    func title() -> String{
        switch self{
        case .dataKill:
            return "Datos Muertes"
        case .dataWeapon:
            return "Datos Armas"
        case .dataSurvival:
            return "Estadisticas Modo Survival"
        case .dataGamesModes:
            return "Modos de juego"
        }
    }
    func image() -> String{
        switch self{
        case .dataKill:
            return "KillData"
        case .dataWeapon:
            return "WeaponData2"
        case .dataSurvival:
            return "SurvivalData"
        case .dataGamesModes:
            return "GamesModesData"
        }
    }
}
