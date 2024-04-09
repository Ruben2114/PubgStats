//
//  StateController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/3/23.
//

import Foundation

enum StateController {
    case success
    case loading
    case fail(error: String)
}

enum Output {
    case fail(error: String)
    case success (model: URLRequest)
    case loading
}
enum OutputPlayer {
    case fail(error: String)
    case success (model: PubgPlayerDTO)
    case loading
}
enum OutputWeapon {
    case fail(error: String)
    case success (model: WeaponDTO)
    case loading
}
enum OutputStats {
    case loading
    case fail(error: String)
    case successSurvival (model: SurvivalDTO)
    case successGamesModes (model: GamesModesDTO)
    case success
}


