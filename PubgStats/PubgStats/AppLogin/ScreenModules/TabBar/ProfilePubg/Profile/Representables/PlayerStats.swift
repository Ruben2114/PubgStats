//
//  PlayerStats.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 25/4/23.
//

import UIKit

enum PlayerStats {
    case wins(GamesModesDataProfileRepresentable)
    case soloWins(GamesModesDataProfileRepresentable)
    case soloFppWins(GamesModesDataProfileRepresentable)
    case duoWins(GamesModesDataProfileRepresentable)
    case duoFppWins(GamesModesDataProfileRepresentable)
    case squadWins(GamesModesDataProfileRepresentable)
    case squadFppWins(GamesModesDataProfileRepresentable)
    case rounds(GamesModesDataProfileRepresentable)
    case soloRounds(GamesModesDataProfileRepresentable)
    case soloFppRounds(GamesModesDataProfileRepresentable)
    case duoRounds(GamesModesDataProfileRepresentable)
    case duoFppRounds(GamesModesDataProfileRepresentable)
    case squadRounds(GamesModesDataProfileRepresentable)
    case squadFppRounds(GamesModesDataProfileRepresentable)
    case kills(GamesModesDataProfileRepresentable)
    case soloKills(GamesModesDataProfileRepresentable)
    case soloFppKills(GamesModesDataProfileRepresentable)
    case duoKills(GamesModesDataProfileRepresentable)
    case duoFppKills(GamesModesDataProfileRepresentable)
    case squadKills(GamesModesDataProfileRepresentable)
    case squadFppKills(GamesModesDataProfileRepresentable)
    
    static func getPlayerCategories(_ data: GamesModesDataProfileRepresentable) -> [(PlayerStats, [PlayerStats])] {
        let kills: (PlayerStats, [PlayerStats]) = (.kills(data) ,[.soloKills(data),
                                                                  .soloFppKills(data),
                                                                  .duoKills(data),
                                                                  .duoFppKills(data),
                                                                  .squadKills(data),
                                                                  .squadFppKills(data)])
        let wins: (PlayerStats, [PlayerStats]) = (.wins(data) ,[.soloWins(data),
                                                                .soloFppWins(data),
                                                                .duoWins(data),
                                                                .duoFppWins(data),
                                                                .squadWins(data),
                                                                .squadFppWins(data)])
        let rounds: (PlayerStats, [PlayerStats]) = (.rounds(data) ,[.soloRounds(data),
                                                                .soloFppRounds(data),
                                                                .duoRounds(data),
                                                                .duoFppRounds(data),
                                                                .squadRounds(data),
                                                                .squadFppRounds(data)])
        return [kills, wins, rounds]
    }
    
    func title() -> String {
        switch self{
        case .wins(_):
            return "wins".localize()
        case .kills(_):
            return "Kills".localize()
        case .rounds(_):
            return "rounds".localize()
        default:
            return type()
        }
    }
    
    func tooltip() -> String {
        switch self{
        case .wins(_):
            return "victorias en los diferentes modos"
        case .kills(_):
            return "Muertes en los diferentes  modos"
        case .rounds(_):
            return "Partidas en los diferentes  modos"
        default:
            return ""
        }
    }
    
    func bottomSheetKey() -> (String, String) {
        switch self{
        case .wins(let data):
            guard let maxWin = data.modes.sorted(by: {$0.wins > $1.wins}).first else { return ("", "") }
            return ("Datos de las victorias", "Si pulsas en cada uno de los sectores de la gráfica podrás ver tus victorias en cada uno de los modos de juegos que existen. Tu máximo de victorias es: \(maxWin.wins) y lo has conseguido en el modo: \(maxWin.mode.localize())")
        case .kills(let data):
            guard let maxKills = data.modes.sorted(by: {$0.kills > $1.kills}).first else { return ("", "") }
            return ("Datos de las muertes", "Si pulsas en cada uno de los sectores de la gráfica podrás ver tus muertes en cada uno de los modos de juegos que existen. Tu máximo de muertes es: \(maxKills.kills) y lo has conseguido en el modo: \(maxKills.mode.localize())")
        case .rounds(let data):
            guard let maxRound = data.modes.sorted(by: {$0.roundsPlayed > $1.roundsPlayed}).first else { return ("", "") }
            return ("Datos de las partidas", "Según tus datos en el modo que has jugado más partidas: \(maxRound.roundsPlayed) es: \(maxRound.mode.localize())")
        default:
            return ("", "")
        }
    }
    
    func color() -> (UIColor, UIColor)? {
        switch self{
        case .soloWins(_), .soloRounds(_), .soloKills(_):
            return (.green, .systemGreen)
        case .soloFppWins(_), .soloFppRounds(_), .soloFppKills(_):
            return (.red, .systemRed)
        case .duoWins(_), .duoRounds(_), .duoKills(_):
            return (.blue, .systemBlue)
        case .duoFppWins(_), .duoFppRounds(_), .duoFppKills(_):
            return (.brown, .systemBrown)
        case .squadWins(_), .squadRounds(_), .squadKills(_):
            return (.purple, .systemPurple)
        case .squadFppWins(_), .squadFppRounds(_), .squadFppKills(_):
            return (.orange, .systemOrange)
        default:
            return nil
        }
    }
    
    func percentage() -> Double {
        switch self{
        case .soloWins(let data), .soloFppWins(let data), .duoWins(let data), .duoFppWins(let data), .squadWins(let data), .squadFppWins(let data):
            let valueSubcategory = data.modes.first(where: {$0.mode == type()})?.wins
            return getSubcategoriesPercentage(valueTotal: data.wonTotal, valueSubcategory: valueSubcategory)
        case .soloRounds(let data), .soloFppRounds(let data), .duoRounds(let data), .duoFppRounds(let data), .squadRounds(let data), .squadFppRounds(let data):
            let valueSubcategory = data.modes.first(where: {$0.mode == type()})?.roundsPlayed
            return getSubcategoriesPercentage(valueTotal: data.gamesPlayed, valueSubcategory: valueSubcategory)
        case .soloKills(let data), .soloFppKills(let data), .duoKills(let data), .duoFppKills(let data), .squadKills(let data), .squadFppKills(let data):
            let valueSubcategory = data.modes.first(where: {$0.mode == type()})?.kills
            return getSubcategoriesPercentage(valueTotal: data.killsTotal, valueSubcategory: valueSubcategory)
        default:
            return 0
        }
    }
    
    func amount() -> String {
        switch self{
        case .soloWins(let data), .soloFppWins(let data), .duoWins(let data), .duoFppWins(let data), .squadWins(let data), .squadFppWins(let data):
            return String(data.modes.first(where: {$0.mode == type()})?.wins ?? 0)
        case .soloRounds(let data), .soloFppRounds(let data), .duoRounds(let data), .duoFppRounds(let data), .squadRounds(let data), .squadFppRounds(let data):
            return String(data.modes.first(where: {$0.mode == type()})?.roundsPlayed ?? 0)
        case .soloKills(let data), .soloFppKills(let data), .duoKills(let data), .duoFppKills(let data), .squadKills(let data), .squadFppKills(let data):
            return String(data.modes.first(where: {$0.mode == type()})?.kills ?? 0)
        case .kills(let data):
            return String(data.killsTotal)
        case .wins(let data):
            return String(data.wonTotal)
        case .rounds(let data):
            return String(data.gamesPlayed)
        }
    }
    
    private func type() -> String {
        switch self{
        case .soloWins(_), .soloRounds(_), .soloKills(_):
            return "solo"
        case .soloFppWins(_), .soloFppRounds(_), .soloFppKills(_):
            return "soloFpp"
        case .duoWins(_), .duoRounds(_), .duoKills(_):
            return "duo"
        case .duoFppWins(_), .duoFppRounds(_), .duoFppKills(_):
            return "duoFpp"
        case .squadWins(_), .squadRounds(_), .squadKills(_):
            return "squad"
        case .squadFppWins(_), .squadFppRounds(_), .squadFppKills(_):
            return "squadFpp"
        default:
            return ""
        }
    }
    
    func getSubcategoriesPercentage(valueTotal: Int, valueSubcategory: Int?) -> Double {
        return Double((valueSubcategory ?? 0) * 100) / Double(valueTotal)
    }
}

