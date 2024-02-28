//
//  PlayerStats.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 25/4/23.
//

import Foundation
import UIKit
//TODO: poner localized y los colores meterlos en el objeto y por orden ascendente y con un maximo de 5 elementos y el resto en gray
enum PlayerStats {
    case kills
    case headshotKills
    case roadKills
    
    case weapons
    
    case distance
    case rideDistance
    case swimDistance
    case walkDistance
    case top10
    case topSolo
    case topDuo
    case topSquad
    case rest
    
    func title() -> String {
        switch self{
        case .kills:
            return "Kills total"
        case .headshotKills:
            return "headshot"
        case .roadKills:
            return "road"
        case .weapons:
            return "Best weapons"
        case .distance:
            return "Distance total"
        case .rideDistance:
            return "ride"
        case .swimDistance:
            return "swim"
        case .walkDistance:
            return "walk"
        case .top10:
            return "top 10 total"
        case .topSolo:
            return "solo"
        case .topDuo:
            return "duo"
        case .topSquad:
            return "squad"
        case .rest:
            return "resto"
        }
    }
    
    func icon() -> String {
        switch self{
        case .kills:
            return "star"
        case .headshotKills:
            return "star"
        case .roadKills:
            return "star"
        case .weapons:
            return "star"
        case .distance:
            return "star"
        case .rideDistance:
            return "star"
        case .swimDistance:
            return "star"
        case .walkDistance:
            return "star"
        case .top10:
            return "star"
        case .topSolo:
            return "star"
        case .topDuo:
            return "star"
        case .topSquad:
            return "star"
        case .rest:
            return "star"
        }
    }
    
    func color() -> (UIColor, UIColor)? {
        switch self{
        case .headshotKills:
            return (.red, .systemRed)
        case .roadKills:
            return (.blue, .systemBlue)
        case .rideDistance:
            return (.red, .systemRed)
        case .swimDistance:
            return (.blue, .systemBlue)
        case .walkDistance:
            return (.green, .systemGreen)
        case .topSolo:
            return (.red, .systemRed)
        case .topDuo:
            return (.blue, .systemBlue)
        case .topSquad:
            return (.green, .systemGreen)
        case.rest:
            return (.gray, .systemGray)
        default:
            return nil
        }
    }
    
    func tooltipLabel() -> String? {
        switch self{
        case .kills:
            return "Datos específicos de las muertes en total"
        case .weapons:
            return "las 5 armas con mas xp son...."
        case .distance:
            return "distancia recorrida en total...."
        case .top10:
            return "tpo 10 en las diferenets categorias...."
        default:
            return nil
        }
    }
}

