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
    @BindingOptional private var attributesHomeList: ProfileAttributesRepresentable?
    
    init(dependencies: AttributesHomeDependencies) {
        self.dependencies = dependencies
        state = stateSubject.eraseToAnyPublisher()
    }
    
    var dataBinding: DataBinding {
        dependencies.resolve()
    }
    
    func viewDidLoad() {
        getAttributes()
    }
    
    func getType() -> AttributesType {
        return attributesHomeList?.infoGamesModes != nil ? .modeGames : .weapons
    }
   
    func goToAttributesDetails(_ select: AttributesHome){
        let attributesDetails: ProfileAttributesDetailsRepresentable?
        switch select.type {
        case .weapons:
            guard let summary = attributesHomeList?.infoWeapon?.weaponSummaries
                .filter({ $0.name == select.title })
                .first else { return }
            let weaponSummary = DefaultAttributesWeaponDetails(weaponDetails: summary,
                                                               killsTotal: getAmountTotal("Kills"),
                                                               damagePlayerTotal: getAmountTotal("DamagePlayer"),
                                                               headShotsTotal: getAmountTotal("HeadShots"),
                                                               groggiesTotal: getAmountTotal("Groggies"))
            attributesDetails = DefaultProfileAttributesDetails(infoWeaponDetails: weaponSummary, type: .weapons)
        case .modeGames:
            guard let summary = attributesHomeList?.infoGamesModes?.modes
                .filter({ $0.mode == select.title })
                .first else { return }
            attributesDetails = DefaultProfileAttributesDetails(infoGamesModesDetails: summary, type: .modeGames)
        case .survival:
            attributesDetails = nil
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
    
    func getAttributes() {
        let attributes: [AttributesHome]? = attributesHomeList?.infoGamesModes != nil ? getAttributesModeGames() : getAttributesWeapons()
        stateSubject.send(attributes)
    }
    
    func getAttributesWeapons() -> [AttributesHome]? {
        return attributesHomeList?.infoWeapon?.weaponSummaries.map{
            DefaultAttributesHome(title: $0.name,
                                  rightAmount: $0.xpTotal,
                                  leftAmount: $0.tierCurrent,
                                  percentage: CGFloat($0.levelCurrent),
                                  image: $0.name,
                                  type: .weapons)
        }
    }
    
    func getAttributesModeGames() -> [AttributesHome]? {
        return attributesHomeList?.infoGamesModes?.modes.map{
            DefaultAttributesHome(title: $0.mode,
                                  rightAmount: $0.wins,
                                  leftAmount: $0.roundsPlayed,
                                  percentage: getPercentage(statistic: Double($0.wins),
                                                            total: Double($0.roundsPlayed)),
                                  image: $0.mode,
                                  type: .modeGames)
        }
    }
    
    func getPercentage(statistic: Double?, total: Double?, optional: Bool = false) -> CGFloat {
        let percentage = statistic != 0 && total != 0 ? ((statistic ?? 0) / (total ?? 0)) : 0
        let optionalPercentage = optional ? percentage : percentage * 100
        return CGFloat(optionalPercentage)
    }
    
    func getAmountTotal(_ key: String) -> Double{
        var value: Double = 0
        attributesHomeList?.infoWeapon?.weaponSummaries.forEach({ summary in
            value += summary.statsTotal.filter({$0.key == key}).compactMap({$0.value}).reduce(0, +)
        })
        return value
    }
}
