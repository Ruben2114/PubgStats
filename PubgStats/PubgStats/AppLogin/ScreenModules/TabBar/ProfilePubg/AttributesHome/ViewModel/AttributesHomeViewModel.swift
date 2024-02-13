//
//  AttributesHomeViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

import Combine
import Foundation

final class AttributesHomeViewModel: DataBindable {
    private var anySubscription: Set<AnyCancellable> = []
    private let dependencies: AttributesHomeDependencies
    private let stateSubject = PassthroughSubject<[AttributesHome]?, Never>()
    var state: AnyPublisher<[AttributesHome]?, Never>
    @BindingOptional private var attributesHomeList: PlayerDetailsRepresentable?
    @BindingOptional private var type: AttributesType?
    
    init(dependencies: AttributesHomeDependencies) {
        self.dependencies = dependencies
        state = stateSubject.eraseToAnyPublisher()
    }
    
    var dataBinding: DataBinding {
        dependencies.resolve()
    }
    
    func viewDidLoad() {
        stateSubject.send(getAttributes())
    }
   
    func goToAttributesDetails(_ select: AttributesHome){
        let attributesDetails: AttributesViewRepresentable?
        switch select.type {
        case .weapons:
            guard let summary = attributesHomeList?.infoWeapon.weaponSummaries
                .filter({ $0.name == select.title })
                .first else { return }
            attributesDetails = getAttributesDetailsWeapons(statistics: summary)
        case .modeGames:
            guard let summary = attributesHomeList?.infoGamesModes.modes
                .filter({ $0.mode == select.title })
                .first else { return }
            attributesDetails = getAttributesDetailsModeGames(statistics: summary)
        }
        coordinator.goToAttributesDetails(attributesDetails)

    }
    
    func backButton() {
        coordinator.goBack()
    }
}

private extension AttributesHomeViewModel {
    var coordinator: AttributesHomeCoordinator {
        return dependencies.resolve()
    }
    
    func getAttributes() -> [AttributesHome] {
        guard let type = type else { return [] }
        switch type {
        case .weapons:
            return attributesHomeList?.infoWeapon.weaponSummaries.map{getAttributesWeapons(statistics: $0)} ?? []
        case .modeGames:
            return attributesHomeList?.infoGamesModes.modes.map{getAttributesModeGames(statistics: $0)} ?? []
        }
    }
}

//MARK: Games Modes Attributes
private extension AttributesHomeViewModel {
    func getAttributesModeGames(statistics: StatisticsGameModesRepresentable) -> AttributesHome {
        return DefaultAttributesHome(title: statistics.mode,
                                     rightAmount: statistics.wins,
                                     leftAmount: statistics.roundsPlayed,
                                     percentage: getPercentage(statistic: Double(statistics.wins),
                                                               total: Double(statistics.roundsPlayed)),
                                     image: statistics.mode,
                                     type: .modeGames)
    }
    
    func getAttributesDetailsModeGames(statistics: StatisticsGameModesRepresentable) -> AttributesViewRepresentable {
        return DefaultAttributesViewRepresentable(title: statistics.mode,
                                                  image: statistics.mode,
                                                  attributesHeaderDetails: [],
                                                  attributesDetails: [],
                                                  type: .modeGames)
    }
    
    func getPercentage(statistic: Double?, total: Double?, optional: Bool = false) -> CGFloat {
        let percentage = statistic != 0 && total != 0 ? ((statistic ?? 0) / (total ?? 0)) : 0
        let optionalPercentage = optional ? percentage : percentage * 100
        return CGFloat(optionalPercentage)
    }
}

//MARK: Weapons Attributes
private extension AttributesHomeViewModel {
    func getAttributesWeapons(statistics: WeaponSummaryRepresentable) -> AttributesHome {
        return DefaultAttributesHome(title: statistics.name,
                                     rightAmount: statistics.xpTotal,
                                     leftAmount: statistics.tierCurrent,
                                     percentage: CGFloat(statistics.levelCurrent),
                                     image: statistics.name,
                                     type: .weapons)
    }
    
    func getAttributesDetailsWeapons(statistics: WeaponSummaryRepresentable) -> AttributesViewRepresentable {
        return DefaultAttributesViewRepresentable(title: statistics.name,
                                                  image: statistics.name,
                                                  attributesHeaderDetails: getAttributesHeaderDetails(statistics),
                                                  attributesDetails: [statistics.statsTotal.map{DefaultAttributesDetails(title: $0.key, //TODO: hacer esto localized
                                                                                                                         amount: String(format: "%.0f", $0.value))}],
                                                  type: .weapons)
    }
    
    func getAttributesHeaderDetails(_ statistics: WeaponSummaryRepresentable) -> [AttributesHeaderDetails] {
        //TODO: poner 4 sino se ve raro
        return statistics.statsTotal.filter({ weapon in
            weapon.key == "Kills" ||
            weapon.key == "DamagePlayer" ||
            weapon.key == "HeadShots" ||
            weapon.key == "Groggies"
        }).map{ value in
            let percentage = getPercentage(statistic: value.value,
                                           total: getTotalPercentageWeapons(value.key))
            return DefaultAttributesHeaderDetails(title: "\(value.key): \(String(format: "%.2f", percentage)) %",
                                                  percentage: percentage)
        }
    }
    
    func getTotalPercentageWeapons(_ key: String) -> Double? {
        var value: Double = 0
        attributesHomeList?.infoWeapon.weaponSummaries.forEach({ summary in
            value += summary.statsTotal.filter({$0.key == key}).compactMap({$0.value}).reduce(0, +)
        })
        return value
    }
    
}



    /*
     return [DefaultAttributesHeaderDetails(title: "Tops 10: \(statistics?.top10S ?? 0)",
                                            percentage: getPercentage(statistic: statistics?.top10S, total: statistics?.roundsPlayed)),
             DefaultAttributesHeaderDetails(title: "Headshot Kills: \(statistics?.headshotKills ?? 0)",
                                            percentage: getPercentage(statistic: statistics?.headshotKills, total: statistics?.kills)),
             DefaultAttributesHeaderDetails(title: "kills per game: \(String(format: "%.2f", killsDay))",
                                            percentage: killsDay),
             DefaultAttributesHeaderDetails(title: "Wins per day: \(String(format: "%.2f", winsDay))",
                                            percentage: winsDay)]
     */
//    func getAttributesDetails(statistics: StatisticsGameModesRepresentable?) -> [[AttributesDetails]] {
//        guard let statistics = statistics else { return []}
//        var attributes: [[AttributesDetails]] = []
//
//
//
//        let attributesSectionOne: [AttributesDetails] = [getAttributesDetails("max Kill Streaks", "\(statistics.maxKillStreaks)", "Kills"),
//                                                         getAttributesDetails("round Most Kills", "\(statistics.roundMostKills)"),
//                                                         getAttributesDetails("killed a teammate", "\(statistics.teamKills)"),
//                                                         getAttributesDetails("road Kills", "\(statistics.roadKills)"),
//                                                         getAttributesDetails("kills", "\(statistics.kills)"),
//                                                         getAttributesDetails("longest Kill", "\(String(format: "%.0f", statistics.longestKill)) m")]
//
//        let attributesSectionTwo: [AttributesDetails] = [getAttributesDetails("longest Time Survived", getTime(statistics.mostSurvivalTime, true), "General"),
//                                                         getAttributesDetails("losses", "\(statistics.losses)"),
//                                                         getAttributesDetails("damage", String(format: "%.0f", statistics.damageDealt)),
//                                                         getAttributesDetails("Asistencias", "\(statistics.assists)"),
//                                                         getAttributesDetails("knocked", "\(statistics.dBNOS)"),
//                                                         getAttributesDetails("suicides", "\(statistics.suicides)"),
//                                                         getAttributesDetails("time Survived", getTime(statistics.timeSurvived)),
//                                                         getAttributesDetails("vehicle Destroys", "\(statistics.vehicleDestroys)"),
//                                                         getAttributesDetails("revives", "\(statistics.revives)")]
//
//        let attributesSectionThree: [AttributesDetails] = [getAttributesDetails("Andando", getDistance(statistics.walkDistance), "Distance"),
//                                                           getAttributesDetails("Conduciendo", getDistance(statistics.rideDistance)),
//                                                           getAttributesDetails("Nadando", getDistance(statistics.swimDistance))]
//
//        let attributesSectionFour: [AttributesDetails] = [getAttributesDetails("boost", "\(statistics.boosts)", "Items"),
//                                                          getAttributesDetails("healing", "\(statistics.heals)"),
//                                                          getAttributesDetails("weapons", "\(statistics.weaponsAcquired)")]
//        [attributesSectionOne, attributesSectionTwo, attributesSectionThree, attributesSectionFour].forEach { data in
//            attributes.append(data)
//        }
//        return attributes
//    }
//
//    func getAttributesDetails(_ title: String, _ amount: String, _ titleSection: String? = nil) -> AttributesDetails {
//        return DefaultAttributesDetails(titleSection: titleSection,
//                                        title: title,
//                                        amount: amount)
//    }
//
//    func getAttributesHeaderDetails(statistics: StatisticsGameModesRepresentable?) -> [AttributesHeaderDetails] {
//        let killsDay = getPercentage(statistic: statistics?.kills, total: statistics?.roundsPlayed, optional: true)
//        let winsDay = getPercentage(statistic: statistics?.wins, total: statistics?.days, optional: true)
//
//        return [DefaultAttributesHeaderDetails(title: "Tops 10: \(statistics?.top10S ?? 0)",
//                                               percentage: getPercentage(statistic: statistics?.top10S, total: statistics?.roundsPlayed)),
//                DefaultAttributesHeaderDetails(title: "Headshot Kills: \(statistics?.headshotKills ?? 0)",
//                                               percentage: getPercentage(statistic: statistics?.headshotKills, total: statistics?.kills)),
//                DefaultAttributesHeaderDetails(title: "kills per game: \(String(format: "%.2f", killsDay))",
//                                               percentage: killsDay),
//                DefaultAttributesHeaderDetails(title: "Wins per day: \(String(format: "%.2f", winsDay))",
//                                               percentage: winsDay)]
//    }
//}
//
////MARK: - Attributes Mode Games
//private extension ProfileViewModel {
//    func getPercentage(statistic: Int?, total: Int?, optional: Bool = false) -> CGFloat {
//        let percentage = statistic != 0 && total != 0 ? (Double(statistic ?? 0) / Double(total ?? 0)) : 0
//        let optionalPercentage = optional ? percentage : percentage * 100
//        return CGFloat(optionalPercentage)
//    }
//
//    func getDistance(_ distance: Double) -> String {
//        let distanceKM = distance / 1000
//        return "\(String(format: "%.2f", distanceKM)) km"
//    }
//
//    func getTime(_ time: Double, _ withMinutes: Bool = false) -> String {
//        let days = Int(round(time / 86400))
//        let hours = Int(round((time.truncatingRemainder(dividingBy: 86400)) / 3600))
//        let minutes = Int(round((time.truncatingRemainder(dividingBy: 3600)) / 60))
//        return withMinutes ? "\(hours) h \(minutes) m" : "\(days) d \(hours) h"
//    }
//}
//
