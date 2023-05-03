//
//  PlayerStats.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 25/4/23.
//

import Foundation

enum PlayerStats {
    case wins(value: CGFloat, average: Double)
    case kills(value: CGFloat, average: Double)
    case losses(value: CGFloat, average: Double)
    case headshotKills(value: CGFloat, average: Double)
    case top10(value: CGFloat, average: Double)
    func value() -> CGFloat{
        switch self{
        case .wins(value: let value, average: let average):
            return CGFloat(max(0,min(value / 100 / average , 1.0)))
        case .kills(value: let value, average: let average):
            return CGFloat(max(0,min(value / 100 / average , 1.0)))
        case .losses(value: let value, average: let average):
            return CGFloat(max(0,min(value / 100 / average , 1.0)))
        case .headshotKills(value: let value, average: let average):
            return CGFloat(max(0,min(value / 100 / average , 1.0)))
        case .top10(value: let value, average: let average):
            return CGFloat(max(0,min(value / 100 / average , 1.0)))
        }
    }
    func title() -> String {
        switch self{
        case .wins(value: let value , average: _):
            return "playerStatsV".localize() + "\(String(format: "%.1f", value))%"
        case .kills(value: let value, average: _):
            return "playerStatsK".localize() + "\(String(format: "%.1f", value))"
        case .losses(value: let value , average: _):
            return "playerStatsD".localize() + "\(String(format: "%.1f", value))"
        case .headshotKills(value: let value , average: _):
            return "playerStatsMD".localize() + "\(String(format: "%.1f", value))"
        case .top10(value: let value , average: _):
            return "playerStatsT".localize() + "\(String(format: "%.1f", value))"
        }
    }
}

