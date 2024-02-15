//
//  GamesModesAttributesDetailsRepresentable.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 15/2/24.
//

import Foundation

enum AttributesDetailsGamesModes {
    case tops10(StatisticsGameModesRepresentable)
    case headshot(StatisticsGameModesRepresentable)
    case killsRound(StatisticsGameModesRepresentable)
    case winsDay(StatisticsGameModesRepresentable)
    
    case kills(StatisticsGameModesRepresentable)
    case maxKillStreaks(StatisticsGameModesRepresentable)
    case roundMostKills(StatisticsGameModesRepresentable)
    case killedTeammate(StatisticsGameModesRepresentable)
    case roadKills(StatisticsGameModesRepresentable)
    case longestKill(StatisticsGameModesRepresentable)
    case longestTimeSurvived(StatisticsGameModesRepresentable)
    case losses(StatisticsGameModesRepresentable)
    case damage(StatisticsGameModesRepresentable)
    case assists(StatisticsGameModesRepresentable)
    case knocked(StatisticsGameModesRepresentable)
    case suicides(StatisticsGameModesRepresentable)
    case timeSurvived(StatisticsGameModesRepresentable)
    case vehicleDestroys(StatisticsGameModesRepresentable)
    case revives(StatisticsGameModesRepresentable)
    case walkDistance(StatisticsGameModesRepresentable)
    case rideDistance(StatisticsGameModesRepresentable)
    case swimDistance(StatisticsGameModesRepresentable)
    case boost(StatisticsGameModesRepresentable)
    case healing(StatisticsGameModesRepresentable)
    case weaponsAcquired(StatisticsGameModesRepresentable)
    
    static func getHeaderStatistics(_ stats: StatisticsGameModesRepresentable) -> [AttributesDetailsGamesModes] {
        return  [.tops10(stats),
                 .headshot(stats),
                 .killsRound(stats),
                 .winsDay(stats)]
    }
    
    static func getStatistics(_ stats: StatisticsGameModesRepresentable) -> [([AttributesDetailsGamesModes], String)] {
        let kills: [AttributesDetailsGamesModes] = [.kills(stats),
                                                    .maxKillStreaks(stats),
                                                    .roundMostKills(stats),
                                                    .killedTeammate(stats),
                                                    .roadKills(stats),
                                                    .longestKill(stats)]
        let general: [AttributesDetailsGamesModes] = [.longestTimeSurvived(stats),
                                                      .losses(stats),
                                                      .damage(stats),
                                                      .assists(stats),
                                                      .knocked(stats),
                                                      .suicides(stats),
                                                      .timeSurvived(stats),
                                                      .vehicleDestroys(stats),
                                                      .revives(stats)]
        let distance: [AttributesDetailsGamesModes] = [.rideDistance(stats),
                                                       .swimDistance(stats),
                                                       .walkDistance(stats)]
        let items: [AttributesDetailsGamesModes] = [.boost(stats),
                                                    .healing(stats),
                                                    .weaponsAcquired(stats)]
        return [(kills, "Kills"),
                (general, "General"),
                (distance, "Distance"),
                (items, "Items")]
    }
    
    func getStats() -> (String, String) {
        switch self {
        case .kills(let stat):
            return ("Kills", "\(stat.kills)")
        case .maxKillStreaks(let stat):
            return ("max Kill Streaks", "\(stat.maxKillStreaks)")
        case .roundMostKills(let stat):
            return ("round Most Kills", "\(stat.roundMostKills)")
        case .killedTeammate(let stat):
            return ("killed a teammate", "\(stat.teamKills)")
        case .roadKills(let stat):
            return ("road Kills", "\(stat.roadKills)")
        case .longestKill(let stat):
            return ("longest Kill", "\(String(format: "%.0f", stat.longestKill)) m")
        case .longestTimeSurvived(let stat):
            return ("longest Time Survived", getTime(stat.mostSurvivalTime, true))
        case .losses(let stat):
            return ("losses", "\(stat.losses)")
        case .damage(let stat):
            return ("damage", String(format: "%.0f", stat.damageDealt))
        case .assists(let stat):
            return ("Asistencias", "\(stat.assists)")
        case .knocked(let stat):
            return ("knocked", "\(stat.dBNOS)")
        case .suicides(let stat):
            return ("suicides", "\(stat.suicides)")
        case .timeSurvived(let stat):
            return ("time Survived", getTime(stat.timeSurvived))
        case .vehicleDestroys(let stat):
            return ("vehicle Destroys", "\(stat.vehicleDestroys)")
        case .revives(let stat):
            return ("revives", "\(stat.revives)")
        case .walkDistance(let stat):
            return ("Andando", getDistance(stat.walkDistance))
        case .rideDistance(let stat):
            return ("Conduciendo", getDistance(stat.rideDistance))
        case .swimDistance(let stat):
            return ("Nadando", getDistance(stat.swimDistance))
        case .boost(let stat):
            return ("boost", "\(stat.boosts)")
        case .healing(let stat):
            return ("healing", "\(stat.heals)")
        case .weaponsAcquired(let stat):
            return ("weaponsAcquired", "\(stat.weaponsAcquired)")
        default:
            return ("", "")
        }
    }
    
    func getHeader() -> (String, CGFloat) {
        switch self {
        case .tops10(let stat):
            return ("Tops 10: \(stat.top10S)", getPercentage(statistic: Double(stat.top10S), total: Double(stat.roundsPlayed)))
        case .headshot(let stat):
            return ("Headshot Kills: \(stat.headshotKills)", getPercentage(statistic: Double(stat.headshotKills), total: Double(stat.kills)))
        case .killsRound(let stat):
            let killsRound = getPercentage(statistic: Double(stat.kills), total: Double(stat.roundsPlayed), optional: true)
            return ("kills per round: \(String(format: "%.2f", killsRound))", killsRound)
        case .winsDay(let stat):
            let winsDay = getPercentage(statistic: Double(stat.wins), total: Double(stat.days), optional: true)
            return ("Wins per day: \(String(format: "%.2f", winsDay))", winsDay)
        default:
            return ("", 0)
        }
    }
    
    func getTime(_ time: Double, _ withMinutes: Bool = false) -> String {
        let days = Int(round(time / 86400))
        let hours = Int(round((time.truncatingRemainder(dividingBy: 86400)) / 3600))
        let minutes = Int(round((time.truncatingRemainder(dividingBy: 3600)) / 60))
        return withMinutes ? "\(hours) h \(minutes) m" : "\(days) d \(hours) h"
    }
    
    func getDistance(_ distance: Double) -> String {
        let distanceKM = distance / 1000
        return "\(String(format: "%.2f", distanceKM)) km"
    }
    
    func getPercentage(statistic: Double?, total: Double?, optional: Bool = false) -> CGFloat {
        let percentage = statistic != 0 && total != 0 ? ((statistic ?? 0) / (total ?? 0)) : 0
        let optionalPercentage = optional ? percentage : percentage * 100
        return CGFloat(optionalPercentage)
    }
}
