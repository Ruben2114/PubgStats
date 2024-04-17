//
//  MatchRepresentable.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 16/4/24.
//

import Foundation

protocol MatchRepresentable {
    var map: String { get }
    var gameMode: String { get }
    var kills: Int { get }
    var damage: Double { get }
    var date: Date? { get }
    var position: Int { get }
}

struct DefaultMatch: MatchRepresentable {
    let map: String
    let gameMode: String
    let kills: Int
    let damage: Double
    let date: Date?
    let position: Int
    
    init(map: String, gameMode: String, kills: Int, damage: Double, date: Date? = nil, position: Int) {
        self.map = map
        self.gameMode = gameMode
        self.kills = kills
        self.damage = damage
        self.date = date
        self.position = position
    }
}
