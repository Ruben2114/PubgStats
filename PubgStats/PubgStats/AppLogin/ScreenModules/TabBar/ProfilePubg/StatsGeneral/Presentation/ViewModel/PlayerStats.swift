//
//  PlayerStats.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 25/4/23.
//

struct PlayerStats {
    var wins: PlayerStatsData
    var suicides: PlayerStatsData
    var losses: PlayerStatsData
    var headshotKills: PlayerStatsData
    var top10: PlayerStatsData
}
struct PlayerStatsData{
    var title: String
    var value: Double
    var averageData: Double
}
