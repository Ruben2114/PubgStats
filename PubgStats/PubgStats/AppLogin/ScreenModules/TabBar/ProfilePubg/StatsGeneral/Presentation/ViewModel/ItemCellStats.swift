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
            return "itemCellStatsDataKill".localize()
        case .dataWeapon:
            return "itemCellStatsDataWeapon".localize()
        case .dataSurvival:
            return "itemCellStatsDataSurvival".localize()
        case .dataGamesModes:
            return "itemCellStatsDataGamesModes".localize()
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
