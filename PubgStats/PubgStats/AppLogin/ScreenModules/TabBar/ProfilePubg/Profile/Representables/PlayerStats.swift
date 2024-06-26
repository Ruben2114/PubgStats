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
            return type().localize().capitalized
        }
    }

    func tooltip() -> String {
        switch self{
        case .wins(_):
            return "profileChartWinsTooltip".localize()
        case .kills(_):
            return "profileChartKillsTooltip".localize()
        case .rounds(_):
            return "profileChartRoundTooltip".localize()
        default:
            return ""
        }
    }
    
    func bottomSheetKey() -> (String, String) {
        switch self{
        case .wins(let data):
            guard let maxWin = data.modes.sorted(by: {$0.wins > $1.wins}).first else { return ("", "") }
            return ("profileChartWinsTitle".localize(), "profileChartWinsSubtitle".localize()
                .placeholderString(replace: .name, value: maxWin.mode.localize())
                .placeholderString(replace: .number, value: String(maxWin.wins)))
        case .kills(let data):
            guard let maxKills = data.modes.sorted(by: {$0.kills > $1.kills}).first else { return ("", "") }
            return ("profileChartKillsTitle".localize(), "profileChartKillsSubtitle".localize()
                .placeholderString(replace: .name, value: maxKills.mode.localize())
                .placeholderString(replace: .number, value: String(maxKills.kills)))
        case .rounds(let data):
            guard let maxRound = data.modes.sorted(by: {$0.roundsPlayed > $1.roundsPlayed}).first else { return ("", "") }
            return ("profileChartRoundTitle".localize(), "profileChartRoundSubtitle".localize()
                .placeholderString(replace: .name, value: maxRound.mode.localize())
                .placeholderString(replace: .number, value: String(maxRound.roundsPlayed)))
        default:
            return ("", "")
        }
    }
    
    func color() -> UIColor {
        switch self{
        case .soloWins(_), .soloRounds(_), .soloKills(_):
            return getColor(red: 72, green: 194, blue: 108)
        case .soloFppWins(_), .soloFppRounds(_), .soloFppKills(_):
            return getColor(red: 255, green: 151, blue: 217)
        case .duoWins(_), .duoRounds(_), .duoKills(_):
            return getColor(red: 171, green: 130, blue: 72)
        case .duoFppWins(_), .duoFppRounds(_), .duoFppKills(_):
            return getColor(red: 167, green: 190, blue: 249)
        case .squadWins(_), .squadRounds(_), .squadKills(_):
            return getColor(red: 171, green: 62, blue: 216)
        case .squadFppWins(_), .squadFppRounds(_), .squadFppKills(_):
            return getColor(red: 238, green: 155, blue: 89)
        default:
            return .systemGray
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
    
    private func getSubcategoriesPercentage(valueTotal: Int, valueSubcategory: Int?) -> Double {
        return Double((valueSubcategory ?? 0) * 100) / Double(valueTotal)
    }
    
    private func getColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
