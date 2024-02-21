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
                                                    .longestKill(stats),
                                                    .headshot(stats)]
        let general: [AttributesDetailsGamesModes] = [.longestTimeSurvived(stats),
                                                      .losses(stats),
                                                      .damage(stats),
                                                      .assists(stats),
                                                      .knocked(stats),
                                                      .suicides(stats),
                                                      .timeSurvived(stats),
                                                      .vehicleDestroys(stats),
                                                      .revives(stats),
                                                      .tops10(stats)]
        let distance: [AttributesDetailsGamesModes] = [.rideDistance(stats),
                                                       .swimDistance(stats),
                                                       .walkDistance(stats)]
        let items: [AttributesDetailsGamesModes] = [.boost(stats),
                                                    .healing(stats),
                                                    .weaponsAcquired(stats)]
        return [(kills, "Kills".localize()),
                (general, "general".localize()),
                (distance, "distance".localize()),
                (items, "items".localize())]
    }
    
    func getStats() -> (String, String) {
        switch self {
        case .kills(let stat):
            return ("kills", "\(stat.kills)")
        case .maxKillStreaks(let stat):
            return ("maxKillStreaks", "\(stat.maxKillStreaks)")
        case .roundMostKills(let stat):
            return ("roundMostKills", "\(stat.roundMostKills)")
        case .killedTeammate(let stat):
            return ("killedTeammate", "\(stat.teamKills)")
        case .roadKills(let stat):
            return ("roadKills", "\(stat.roadKills)")
        case .longestKill(let stat):
            return ("longestKill", "\(String(format: "%.0f", stat.longestKill)) m")
        case .longestTimeSurvived(let stat):
            return ("longestTimeSurvived", getTime(stat.mostSurvivalTime, true))
        case .losses(let stat):
            return ("losses", "\(stat.losses)")
        case .damage(let stat):
            return ("damage", String(format: "%.0f", stat.damageDealt))
        case .assists(let stat):
            return ("assists", "\(stat.assists)")
        case .knocked(let stat):
            return ("knocked", "\(stat.dBNOS)")
        case .suicides(let stat):
            return ("suicides", "\(stat.suicides)")
        case .timeSurvived(let stat):
            return ("timeSurvived", getTime(stat.timeSurvived))
        case .vehicleDestroys(let stat):
            return ("vehicleDestroys", "\(stat.vehicleDestroys)")
        case .revives(let stat):
            return ("revives", "\(stat.revives)")
        case .walkDistance(let stat):
            return ("walkDistance", getDistance(stat.walkDistance))
        case .rideDistance(let stat):
            return ("rideDistance", getDistance(stat.rideDistance))
        case .swimDistance(let stat):
            return ("swimDistance", getDistance(stat.swimDistance))
        case .boost(let stat):
            return ("boost", "\(stat.boosts)")
        case .healing(let stat):
            return ("healing", "\(stat.heals)")
        case .weaponsAcquired(let stat):
            return ("weaponsAcquired", "\(stat.weaponsAcquired)")
        case .tops10(let stat):
            return ("Tops 10", "\(stat.top10S)")
        case .headshot(let stat):
            return ("headshotKills", "\(stat.headshotKills)")
        default:
            return ("", "")
        }
    }
    
    func getHeader() -> (String, CGFloat) {
        //TODO: meter top10 y heasshot en la vista y en el header mostrar su %
        switch self {
        case .tops10(let stat):
            let top10 = getPercentage(statistic: Double(stat.top10S), total: Double(stat.roundsPlayed))
            return ("Tops 10: \(String(format: "%.0f", top10)) %", top10)
        case .headshot(let stat):
            let headshotKills = getPercentage(statistic: Double(stat.headshotKills), total: Double(stat.kills))
            return ("\("headshotKills".localize()): \(String(format: "%.0f", headshotKills)) %", headshotKills)
        case .killsRound(let stat):
            let killsRound = getPercentage(statistic: Double(stat.kills), total: Double(stat.roundsPlayed), optional: true)
            return ("\("killsRound".localize()): \(String(format: "%.1f", killsRound))", killsRound)
        case .winsDay(let stat):
            let winsDay = getPercentage(statistic: Double(stat.wins), total: Double(stat.days), optional: true)
            return ("\("winsDay".localize()): \(String(format: "%.1f", winsDay))", winsDay)
        default:
            return ("", 0)
        }
    }
    
    private func getTime(_ time: Double, _ withMinutes: Bool = false) -> String {
        let days = Int(round(time / 86400))
        let hours = Int(round((time.truncatingRemainder(dividingBy: 86400)) / 3600))
        let minutes = Int(round((time.truncatingRemainder(dividingBy: 3600)) / 60))
        return withMinutes ? "\(hours) h \(minutes) m" : "\(days) d \(hours) h"
    }
    
    private func getDistance(_ distance: Double) -> String {
        let distanceKM = distance / 1000
        return "\(String(format: "%.2f", distanceKM)) km"
    }
    
    private func getPercentage(statistic: Double?, total: Double?, optional: Bool = false) -> CGFloat {
        let percentage = statistic != 0 && total != 0 ? ((statistic ?? 0) / (total ?? 0)) : 0
        let optionalPercentage = optional ? percentage : percentage * 100
        return CGFloat(optionalPercentage)
    }
}
