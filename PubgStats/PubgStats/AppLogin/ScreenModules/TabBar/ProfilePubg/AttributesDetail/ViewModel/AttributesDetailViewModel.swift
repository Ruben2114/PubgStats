//
//  AttributesDetailViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

import Combine
import Foundation

enum AttributesDetailState {
    case idle
    case showWeaponOrGamesModes(AttributesViewRepresentable?)
    case showSurvival(AttributesHome, AttributesViewRepresentable)
}

final class AttributesDetailViewModel: DataBindable {
    private var anySubscription: Set<AnyCancellable> = []
    private let dependencies: AttributesDetailDependencies
    private let stateSubject = PassthroughSubject<AttributesDetailState, Never>()
    var state: AnyPublisher<AttributesDetailState, Never>
    @BindingOptional private var attributesDetailList: ProfileAttributesDetailsRepresentable?
    
    init(dependencies: AttributesDetailDependencies) {
        self.dependencies = dependencies
        state = stateSubject.eraseToAnyPublisher()
    }
    
    var dataBinding: DataBinding {
        dependencies.resolve()
    }
    
    func viewDidLoad() {
        getAttributes()
    }
    
    func backButton() {
        coordinator.goBack()
    }
}

private extension AttributesDetailViewModel {
    var coordinator: AttributesDetailCoordinator {
        return dependencies.resolve()
    }
    
    func getAttributes() {
        guard let attributes = attributesDetailList else { return }
        switch attributes.type {
        case .weapons:
            return stateSubject.send(.showWeaponOrGamesModes(getAttributesDetailsWeapons()))
        case .modeGames:
            return stateSubject.send(.showWeaponOrGamesModes(getAttributesDetailsModeGames()))
        case .survival:
            return getAttributesDetailsSurvival()
        }
    }
}

//MARK: - Games Modes Attributes
private extension AttributesDetailViewModel {
    func getAttributesDetailsModeGames() -> AttributesViewRepresentable {
        return DefaultAttributesViewRepresentable(title: attributesDetailList?.infoGamesModesDetails?.mode ?? "",
                                                  image: attributesDetailList?.infoGamesModesDetails?.mode ?? "",
                                                  attributesHeaderDetails: getAttributesHeaderGamesModes(),
                                                  attributesDetails: getAttributesDetailsGamesModes(),
                                                  type: .modeGames)
    }
    
    func getAttributesHeaderGamesModes() -> [AttributesHeaderDetails] {
        guard let statistics = attributesDetailList?.infoGamesModesDetails else { return [] }
        let attributesHeader = AttributesDetailsGamesModes.getHeaderStatistics(statistics)
            .map({DefaultAttributesHeaderDetails(title: $0.getHeader().0, percentage: $0.getHeader().1)})
        return attributesHeader
    }
    
    func getAttributesDetailsGamesModes() -> [[AttributesDetails]] {
        guard let statistics = attributesDetailList?.infoGamesModesDetails else { return []}
        var attributes: [[AttributesDetails]] = []
        let attributesDetails = AttributesDetailsGamesModes.getStatistics(statistics)
        for detail in attributesDetails {
            let data = detail.0.map({ DefaultAttributesDetails(titleSection: detail.1, title: $0.getStats().0, amount: $0.getStats().1)})
            attributes.append(data)
        }
        return attributes
    }
}

//MARK: - Weapons Attributes
private extension AttributesDetailViewModel {
    func getAttributesDetailsWeapons() -> AttributesViewRepresentable? {
        guard let statistics = attributesDetailList?.infoWeaponDetails?.weaponDetails.statsTotal else { return nil }
        let attributesDetails = statistics.map {DefaultAttributesDetails(titleSection: "Detalles",
                                                                         title: $0.key, //TODO: hacer esto localized
                                                                         amount: String(format: "%.0f", $0.value))}
        let name = attributesDetailList?.infoWeaponDetails?.weaponDetails.name ?? ""
        return DefaultAttributesViewRepresentable(title: name,
                                                  image: name,
                                                  attributesHeaderDetails: getAttributesHeaderDetails(),
                                                  attributesDetails: [attributesDetails],
                                                  type: .weapons)
    }
    
    func getAttributesHeaderDetails() -> [AttributesHeaderDetails] {
        guard let statistics = attributesDetailList?.infoWeaponDetails else { return []}
        return statistics.weaponDetails.statsTotal.filter({ weapon in
            weapon.key == "Kills" ||
            weapon.key == "DamagePlayer" ||
            weapon.key == "HeadShots" ||
            weapon.key == "Groggies"
        }).map{ value in
            let totalWeapons = getTotalWeapons(value.key, statistics)
            return DefaultAttributesHeaderDetails(title: "\(totalWeapons.0): \(String(format: "%.2f", totalWeapons.1)) %",
                                                  percentage: getPercentage(statistic: value.value,
                                                                            total: totalWeapons.1))
        }
    }
    
    func getPercentage(statistic: Double?, total: Double?, optional: Bool = false) -> CGFloat {
        let percentage = statistic != 0 && total != 0 ? ((statistic ?? 0) / (total ?? 0)) : 0
        let optionalPercentage = optional ? percentage : percentage * 100
        return CGFloat(optionalPercentage)
    }
    
    func getTotalWeapons(_ key: String,_ statistics: AttributesWeaponDetailsRepresentable) -> (String, Double) {
        switch key {
        case "Kills": return ("Kills", statistics.killsTotal)
        case "DamagePlayer": return ("Damage", statistics.damagePlayerTotal)
        case "HeadShots": return ("HeadShots", statistics.headShotsTotal)
        case "Groggies": return ("Groggies", statistics.groggiesTotal)
        default:
            return ("", 0)
        }
    }
}

//MARK: - Survival
extension AttributesDetailViewModel {
    func getAttributesDetailsSurvival() {
        guard let statistics = attributesDetailList?.infoSurvivalDetails else { return }
        let attributesDetails = AttributesDetailsSurvival.getStatistics(statistics)
            .map({DefaultAttributesDetails(titleSection: "Detalles", title: $0.getStats().0, amount: $0.getStats().1)})
        
        let attributesHome = DefaultAttributesHome(title: "Level \(statistics.level)",
                                                   rightAmount: Int(statistics.totalMatchesPlayed),
                                                   leftAmount: Int(statistics.xp),
                                                   percentage: getPercentage(statistic: Double(statistics.stats.top10 ?? "0"),
                                                                             total: Double(statistics.totalMatchesPlayed)),
                                                   image: "star",
                                                   type: .survival)
        
        let attributes = DefaultAttributesViewRepresentable(title: "Survival",
                                                            image: "star",
                                                            attributesHeaderDetails: [],
                                                            attributesDetails: [attributesDetails],
                                                            type: .survival)
        stateSubject.send(.showSurvival(attributesHome, attributes))
    }
}
