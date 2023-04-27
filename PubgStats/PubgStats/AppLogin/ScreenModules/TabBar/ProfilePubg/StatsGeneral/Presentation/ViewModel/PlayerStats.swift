//
//  PlayerStats.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 25/4/23.
//

import Foundation

enum PlayerStats2 {
    case wins(title: String, value: CGFloat)
    case kills(title: String, value: CGFloat)
    case losses(title: String, value: CGFloat)
    case headshotKills(title: String, value: CGFloat)
    case top10(title: String, value: CGFloat)
    func value() -> CGFloat{
        switch self{
        case .wins(title: _, value: let value):
            return value
        case .kills(title: _, value: let value):
            return value
        case .losses(title: _, value: let value):
            return value
        case .headshotKills(title: _, value: let value):
            return value
        case .top10(title: _, value: let value):
            return value
        }
    }
    func title() -> String {
        switch self{
        case .wins(title: let title, value: _):
            return title
        case .kills(title: let title, value: _):
            return title
        case .losses(title: let title, value: _):
            return title
        case .headshotKills(title: let title, value: _):
            return title
        case .top10(title: let title, value: _):
            return title
        }
    }
}


