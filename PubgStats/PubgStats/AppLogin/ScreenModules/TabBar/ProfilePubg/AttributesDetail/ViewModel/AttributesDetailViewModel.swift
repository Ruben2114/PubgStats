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
    case showSurvival(AttributesHome, AttributesViewRepresentable?)
}

final class AttributesDetailViewModel: DataBindable {
    private var anySubscription: Set<AnyCancellable> = []
    private let dependencies: AttributesDetailDependencies
    private let stateSubject = PassthroughSubject<AttributesDetailState, Never>()
    var state: AnyPublisher<AttributesDetailState, Never>
    @BindingOptional private var attributesDetailList: ProfileAttributesDetailsRepresentable?
    var model: AttributesViewRepresentable?
    
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
            model = getAttributesDetailsWeapons()
        case .modeGames:
            model = getAttributesDetailsModeGames()
        case .survival:
            return getAttributesDetailsSurvival()
        }
        stateSubject.send(.showWeaponOrGamesModes(model))
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
            let data = detail.0.map({ DefaultAttributesDetails(titleSection: detail.1.capitalized, title: $0.getStats().0.localize(), amount: $0.getStats().1.formattedString())})
            attributes.append(data)
        }
        return attributes
    }
}

//MARK: - Weapons Attributes
private extension AttributesDetailViewModel {
    func getAttributesDetailsWeapons() -> AttributesViewRepresentable? {
        guard let statistics = attributesDetailList?.infoWeaponDetails else { return nil }
        let attributesHeaderDetails = AttributesDetailsWeapon.getDetailsStatistics(statistics).map{DefaultAttributesHeaderDetails(title: $0.getHeader().0, percentage: $0.getHeader().1)}
        let attributesDetails = AttributesDetailsWeapon.getHeaderStatistics(statistics).map{$0.getDetails()}
        return DefaultAttributesViewRepresentable(title: attributesDetailList?.infoWeaponDetails?.weaponDetails.name ?? "",
                                                  image: attributesDetailList?.infoWeaponDetails?.weaponDetails.name ?? "",
                                                  attributesHeaderDetails: attributesHeaderDetails,
                                                  attributesDetails: attributesDetails,
                                                  type: .weapons)
    }
}

//MARK: - Survival
private extension AttributesDetailViewModel {
    func getAttributesDetailsSurvival() {
        guard let statistics = attributesDetailList?.infoSurvivalDetails else { return }
        let attributesDetails = AttributesDetailsSurvival.getStatistics(statistics)
            .map({DefaultAttributesDetails(titleSection: "details".localize(), title: $0.getStats().0.localize(), amount: $0.getStats().1.formattedString())})
        
        let attributesHome = DefaultAttributesHome(title: "Level \(statistics.level)",
                                                   rightAmount: Int(statistics.xp),
                                                   leftAmount: Int(statistics.totalMatchesPlayed),
                                                   percentage: getPercentage(statistic: Double(statistics.stats.top10 ?? "0"),
                                                                             total: Double(statistics.totalMatchesPlayed)),
                                                   image: getImage(Int(statistics.level) ?? 0),
                                                   type: .survival)
        
        model = DefaultAttributesViewRepresentable(title: "survivalDataViewControllerTitle".localize(),
                                                   image: "",
                                                   attributesHeaderDetails: [],
                                                   attributesDetails: [attributesDetails],
                                                   type: .survival)
        stateSubject.send(.showSurvival(attributesHome, model))
    }
    
    func getPercentage(statistic: Double?, total: Double?, optional: Bool = false) -> CGFloat {
        let percentage = statistic != 0 && total != 0 ? ((statistic ?? 0) / (total ?? 0)) : 0
        let optionalPercentage = optional ? percentage : percentage * 100
        return CGFloat(optionalPercentage)
    }
    
    func getImage(_ level: Int) -> String {
        switch level {
        case 0: return "Rookie"
        case 1..<40: return "Bronze"
        case 40..<80: return "Diamond"
        case 80..<120: return "Gold"
        case 120..<160: return "Platinum"
        case 160..<200: return "Silver"
        default:
            return "Rookie"
        }
    }
}
