//
//  AttributesDetailViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

import Combine
import Foundation

final class AttributesDetailViewModel: DataBindable {
    private var anySubscription: Set<AnyCancellable> = []
    private let dependencies: AttributesDetailDependencies
    private let stateSubject = PassthroughSubject<AttributesViewRepresentable?, Never>()
    var state: AnyPublisher<AttributesViewRepresentable?, Never>
    @BindingOptional private var attributesDetailList: ProfileAttributesDetailsRepresentable?
    
    init(dependencies: AttributesDetailDependencies) {
        self.dependencies = dependencies
        state = stateSubject.eraseToAnyPublisher()
    }
    
    var dataBinding: DataBinding {
        dependencies.resolve()
    }
    
    func viewDidLoad() {
        stateSubject.send(getAttributes())
    }
    
    func backButton() {
        coordinator.goBack()
    }
}

private extension AttributesDetailViewModel {
    var coordinator: AttributesDetailCoordinator {
        return dependencies.resolve()
    }
    
    func getAttributes() -> AttributesViewRepresentable? {
        guard let attributes = attributesDetailList else { return nil }
        switch attributes.type {
        case .weapons:
            return getAttributesDetailsWeapons()
        case .modeGames:
            return getAttributesDetailsModeGames(statistics: attributes.infoGamesModesDetails)
        case .survival:
            return nil
        }
    }
}

//MARK: - Games Modes Attributes
private extension AttributesDetailViewModel {
    enum AttributesHeaderGamesModes: CaseIterable {
        case tops10, headshot, killsRound, winsDay
    }
    
    func getAttributesDetailsModeGames(statistics: StatisticsGameModesRepresentable?) -> AttributesViewRepresentable {
        return DefaultAttributesViewRepresentable(title: statistics?.mode ?? "",
                                                  image: statistics?.mode ?? "",
                                                  attributesHeaderDetails: getAttributesHeaderGamesModes(),
                                                  attributesDetails: getAttributesDetailsGamesModes(statistics),
                                                  type: .modeGames)
    }
    
    func getAttributesHeaderGamesModes() -> [AttributesHeaderDetails] {
        guard let statistics = attributesDetailList?.infoGamesModesDetails else { return [] }
        var attributesHeaderDetails: [AttributesHeaderDetails] = []
        for type in AttributesHeaderGamesModes.allCases {
            attributesHeaderDetails.append(createAttributesHeaderGamesModes(type, statistics))
        }
        return attributesHeaderDetails
    }
    
    func createAttributesHeaderGamesModes(_ type: AttributesHeaderGamesModes, _ statistics: StatisticsGameModesRepresentable) -> AttributesHeaderDetails {
        switch type {
        case .tops10:
            return DefaultAttributesHeaderDetails(title: "Tops 10: \(statistics.top10S)",
                                                  percentage: getPercentage(statistic: Double(statistics.top10S), total: Double(statistics.roundsPlayed)))
        case .headshot:
            return DefaultAttributesHeaderDetails(title: "Headshot Kills: \(statistics.headshotKills)",
                                                  percentage: getPercentage(statistic: Double(statistics.headshotKills), total: Double(statistics.kills)))
        case .killsRound:
            let killsRound = getPercentage(statistic: Double(statistics.kills), total: Double(statistics.roundsPlayed), optional: true)
            return DefaultAttributesHeaderDetails(title: "kills per round: \(String(format: "%.2f", killsRound))",
                                                  percentage: killsRound)
        case .winsDay:
            let winsDay = getPercentage(statistic: Double(statistics.wins), total: Double(statistics.days), optional: true)
            return DefaultAttributesHeaderDetails(title: "Wins per day: \(String(format: "%.2f", winsDay))",
                                                  percentage: winsDay)
        }
    }
    
    func getAttributesDetailsGamesModes(_ statistics: StatisticsGameModesRepresentable?) -> [[AttributesDetails]] {
        guard let statistics = statistics else { return []}
        var attributes: [[AttributesDetails]] = []
        
        let attributesSectionOne: [AttributesDetails] = [getAttributesDetails("max Kill Streaks", "\(statistics.maxKillStreaks)", "Kills"),
                                                         getAttributesDetails("round Most Kills", "\(statistics.roundMostKills)"),
                                                         getAttributesDetails("killed a teammate", "\(statistics.teamKills)"),
                                                         getAttributesDetails("road Kills", "\(statistics.roadKills)"),
                                                         getAttributesDetails("kills", "\(statistics.kills)"),
                                                         getAttributesDetails("longest Kill", "\(String(format: "%.0f", statistics.longestKill)) m")]
        
        let attributesSectionTwo: [AttributesDetails] = [getAttributesDetails("longest Time Survived", getTime(statistics.mostSurvivalTime, true), "General"),
                                                         getAttributesDetails("losses", "\(statistics.losses)"),
                                                         getAttributesDetails("damage", String(format: "%.0f", statistics.damageDealt)),
                                                         getAttributesDetails("Asistencias", "\(statistics.assists)"),
                                                         getAttributesDetails("knocked", "\(statistics.dBNOS)"),
                                                         getAttributesDetails("suicides", "\(statistics.suicides)"),
                                                         getAttributesDetails("time Survived", getTime(statistics.timeSurvived)),
                                                         getAttributesDetails("vehicle Destroys", "\(statistics.vehicleDestroys)"),
                                                         getAttributesDetails("revives", "\(statistics.revives)")]
        
        let attributesSectionThree: [AttributesDetails] = [getAttributesDetails("Andando", getDistance(statistics.walkDistance), "Distance"),
                                                           getAttributesDetails("Conduciendo", getDistance(statistics.rideDistance)),
                                                           getAttributesDetails("Nadando", getDistance(statistics.swimDistance))]
        
        let attributesSectionFour: [AttributesDetails] = [getAttributesDetails("boost", "\(statistics.boosts)", "Items"),
                                                          getAttributesDetails("healing", "\(statistics.heals)"),
                                                          getAttributesDetails("weapons", "\(statistics.weaponsAcquired)")]
        [attributesSectionOne, attributesSectionTwo, attributesSectionThree, attributesSectionFour].forEach { data in
            attributes.append(data)
        }
        return attributes
    }
    
    func getAttributesDetails(_ title: String, _ amount: String, _ titleSection: String? = nil) -> AttributesDetails {
        return DefaultAttributesDetails(titleSection: titleSection,
                                        title: title,
                                        amount: amount)
    }
    
    func getPercentage(statistic: Double?, total: Double?, optional: Bool = false) -> CGFloat {
        let percentage = statistic != 0 && total != 0 ? ((statistic ?? 0) / (total ?? 0)) : 0
        let optionalPercentage = optional ? percentage : percentage * 100
        return CGFloat(optionalPercentage)
    }
    
    func getDistance(_ distance: Double) -> String {
        let distanceKM = distance / 1000
        return "\(String(format: "%.2f", distanceKM)) km"
    }
    
    func getTime(_ time: Double, _ withMinutes: Bool = false) -> String {
        let days = Int(round(time / 86400))
        let hours = Int(round((time.truncatingRemainder(dividingBy: 86400)) / 3600))
        let minutes = Int(round((time.truncatingRemainder(dividingBy: 3600)) / 60))
        return withMinutes ? "\(hours) h \(minutes) m" : "\(days) d \(hours) h"
    }
}

//MARK: - Weapons Attributes
private extension AttributesDetailViewModel {
    func getAttributesDetailsWeapons() -> AttributesViewRepresentable? {
        guard let statistics = attributesDetailList?.infoWeaponDetails?.statsTotal else { return nil }
        let attributesDetails = statistics.map {DefaultAttributesDetails(title: $0.key, //TODO: hacer esto localized
                                                                         amount: String(format: "%.0f", $0.value))}
        let name = attributesDetailList?.infoWeaponDetails?.name ?? ""
        return DefaultAttributesViewRepresentable(title: name,
                                                  image: name,
                                                  attributesHeaderDetails: getAttributesHeaderDetails(),
                                                  attributesDetails: [attributesDetails],
                                                  type: .weapons)
    }
    
    func getAttributesHeaderDetails() -> [AttributesHeaderDetails] {
        guard let statistics = attributesDetailList?.infoWeaponDetails else { return []}
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
//        var value: Double = 0
//        //TODO: enviar en el representable estos 4 datos o el representable del weapons, todo como un strut
//        attributesHomeList?.infoWeapon?.weaponSummaries.forEach({ summary in
//            value += summary.statsTotal.filter({$0.key == key}).compactMap({$0.value}).reduce(0, +)
//        })
//        return value
        return 0
    }
}
