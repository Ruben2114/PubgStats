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
            return "default"
        case .dataWeapon:
            return "default"
        case .dataSurvival:
            return "default"
        case .dataGamesModes:
            return "default"
        }
    }
}
