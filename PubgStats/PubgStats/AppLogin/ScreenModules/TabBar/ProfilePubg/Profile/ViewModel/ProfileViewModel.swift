//
//  ProfileViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 21/3/23.
//

import Foundation
import Combine

enum ProfileState {
    case idle
    case showChartView([PieChartViewDataRepresentable]?)
    case showErrorPlayerDetails
    case hideLoading
    case showHeader(ProfileHeaderViewRepresentable)
    case showDataGeneral(GamesModesDataProfileRepresentable)
}

final class ProfileViewModel: DataBindable {
    private var anySubscription: Set<AnyCancellable> = []
    private let dependencies: ProfileDependencies
    private let stateSubject = CurrentValueSubject<ProfileState, Never>(.idle)
    var state: AnyPublisher<ProfileState, Never>
    private let getPlayerDetailsSubject = PassthroughSubject<(IdAccountDataProfileRepresentable, Bool), Never>()
    @BindingOptional private var dataProfile: IdAccountDataProfileRepresentable?
    private var representable: PlayerDetailsRepresentable?
    
    init(dependencies: ProfileDependencies) {
        self.dependencies = dependencies
        state = stateSubject.eraseToAnyPublisher()
    }
    
    var dataBinding: DataBinding {
        dependencies.resolve()
    }
    
    func viewDidLoad() {
        subscribePlayerDetailsPublisher()
        reloadData()
    }
    
    func goToModes() {
        let attributes = DefaultProfileAttributes(infoGamesModes: representable?.infoGamesModes)
        coordinator.goToAttributes(attributes: attributes)
    }
    
    func goToWeapon() {
        let attributes = DefaultProfileAttributes(infoWeapon: representable?.infoWeapon)
        coordinator.goToAttributes(attributes: attributes)
    }
    
    func goToSurvival() {
        let attributesDetails = DefaultProfileAttributesDetails(infoSurvivalDetails: representable?.infoSurvival, type: .survival)
        coordinator.goToAttributesDetails(attributesDetails)
    }
    
    func reload(){
        getPlayerDetailsSubject.send((dataProfile ?? DefaultIdAccountDataProfile(id: "", name: "", platform: ""), true))
    }
}

private extension ProfileViewModel {
    var coordinator: ProfileCoordinator {
        return dependencies.resolve()
    }
    
    var profileDataUseCase: ProfileDataUseCase {
        return dependencies.resolve()
    }
    
    func getChartData(infoGamesModes: GamesModesDataProfileRepresentable) {
        let chartData = PlayerStats.getPlayerCategories(infoGamesModes)
            .map {DefaultPieChartViewData(centerIconKey: $0.0.icon(),
                                          centerTitleText: $0.0.amount(),
                                          centerSubtitleText: $0.0.title(),
                                          categories: $0.1.filter({$0.percentage() != 0})
                .map { getSubcategoriesData(stats: $0)},
                                          tooltipLabelTextKey: $0.0.tooltip(), 
                                          bottomSheetKey: $0.0.bottomSheetKey()) }
        stateSubject.send(.showChartView(chartData))
    }
    
    func reloadData() {
        let valueDate = UserDefaults.standard.object(forKey: "date")
        if valueDate != nil {
            let interval = Date().timeIntervalSince(valueDate as? Date ?? Date()) > 86400
            if interval { UserDefaults.standard.set(nil, forKey: "date") }
            getPlayerDetailsSubject.send((dataProfile ?? DefaultIdAccountDataProfile(id: "", name: "", platform: ""), interval))
        } else {
            getPlayerDetailsSubject.send((dataProfile ?? DefaultIdAccountDataProfile(id: "", name: "", platform: ""), false))
            UserDefaults.standard.set(Date(), forKey: "date")
        }
    }
    
    func getSubcategoriesData(stats: PlayerStats) -> CategoryRepresentable {
        DefaultCategory(percentage: stats.percentage(),
                        color: stats.color()?.0 ?? .gray,
                        secundaryColor: stats.color()?.1 ?? .systemGray,
                        currentCenterTitleText: stats.amount(),
                        currentSubTitleText: stats.title(),
                        icon: stats.icon())
    }
    
    func getSubcategoriesPercentage(valueTotal: Int, valueSubcategory: Int) -> Double {
        let amount: Decimal = Decimal(valueSubcategory * 100) / Decimal(valueTotal)
        return NSDecimalNumber(decimal: amount).doubleValue
    }
    
    func getProfileHeader(_ info: SurvivalDataProfileRepresentable) {
        let profileHeader = DefaultProfileHeaderView(dataPlayer: dataProfile ?? DefaultIdAccountDataProfile(id: "", name: "", platform: ""),
                                                     level: info.level,
                                                     xp: info.xp)
        stateSubject.send(.showHeader(profileHeader))
    }
}


//MARK: - Subscriptions
private extension ProfileViewModel {
    func subscribePlayerDetailsPublisher() {
        playerDetailsPublisher().sink { [weak self] completion in
            switch completion {
            case .failure(_):
                self?.stateSubject.send(.showErrorPlayerDetails)
                self?.stateSubject.send(.hideLoading)
                self?.subscribePlayerDetailsPublisher()
            default: break
            }
        } receiveValue: { [weak self] data in
            self?.representable = data
            self?.stateSubject.send(.showDataGeneral(data.infoGamesModes))
            self?.getProfileHeader(data.infoSurvival)
            self?.getChartData(infoGamesModes: data.infoGamesModes)
            self?.stateSubject.send(.hideLoading)
        }.store(in: &anySubscription)
    }
}

//MARK: - Publishers

private extension ProfileViewModel {
    func playerDetailsPublisher() -> AnyPublisher<PlayerDetailsRepresentable, Error> {
        return getPlayerDetailsSubject.flatMap { [unowned self] data, reload in
            self.profileDataUseCase.fetchPlayerDetails(data, reload: reload)
        }.receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
