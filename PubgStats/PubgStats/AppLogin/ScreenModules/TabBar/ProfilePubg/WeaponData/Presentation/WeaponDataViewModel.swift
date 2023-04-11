//
//  WeaponDataViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//
import Combine

final class WeaponDataViewModel {
    private let apiService: ApiClientService
    var state = PassthroughSubject<OutputWeapon, Never>()
    private let dependencies: WeaponDataDependency
    private weak var coordinator: WeaponDataCoordinator?
    private let weaponDataUseCase: WeaponDataUseCase
    var dataKillsDict: [String: Int] = [:]
    
    init(dependencies: WeaponDataDependency, apiService: ApiClientService = ApiClientServiceImp()) {
        self.apiService = apiService
        self.dependencies = dependencies
        self.coordinator = dependencies.resolve()
        self.weaponDataUseCase = dependencies.resolve()
    }
    func fetchDataGeneral(account: String) {
        state.send(.loading)
        weaponDataUseCase.execute(account: account) { [weak self] result in
            switch result {
            case .success(let weapon):
                self?.state.send(.success(model: weapon))
            case .failure(let error):
                self?.state.send(.fail(error: "\(error)"))
            }
        }
    }
    func saveSurvivalData(weaponData: [WeaponDTO]) {
        let sessionUser: ProfileEntity = dependencies.external.resolve()
        sessionUser.weapons = weaponData
    }
    func backButton() {
        coordinator?.dismiss()
    }
    func goWeaponItem(weapon: String){
        let sessionUser: ProfileEntity = dependencies.external.resolve()
        sessionUser.weapon = weapon
        coordinator?.performTransition(.goWeapon)
    }
}

/*
 WeaponDTO(data: PubgStats.WeaponDataDTO(attributes: PubgStats.WeaponAttributesDTO(weaponSummaries: ["BizonPP19": PubgStats.WeaponSummaryDTO(xpTotal: 9267, levelCurrent: 4, tierCurrent: 1, statsTotal: ["MostHeadShotsInAGame": 0.0, "MostDamagePlayerInAGame": 260.1200008392334, "MostGroggiesInAGame": 1.0, "MostKillsInAGame": 2.0, "DamagePlayer": 398.8218116760254, "LongRangeDefeats": 0.0, "Groggies": 1.0, "LongestDefeat": 46.43193054199219, "HeadShots": 0.0, "MostDefeatsInAGame": 2.0, "Defeats": 2.0, "Kills": 2.0]), "K2": PubgStats.WeaponSummaryDTO(xpTotal: 7664, levelCurrent: 4, tierCurrent: 1, statsTotal: ["Defeats": 2.0, "LongRangeDefeats": 0.0, "MostHeadShotsInAGame": 1.0, "MostDamagePlayerInAGame": 122.14000129699707, "DamagePlayer": 274.1929397583008, "LongestDefeat": 46.28129577636719, "Groggies": 2.0, "MostKillsInAGame": 1.0, "MostGroggiesInAGame": 1.0, "MostDefeatsInAGame": 1.0, "HeadShots": 1.0, "Kills": 1.0]), "UMP": PubgStats.WeaponSummaryDTO(xpTotal: 16245, levelCurrent: 7, tierCurrent: 1, statsTotal: ["DamagePlayer": 689.1408195495605, "Kills": 6.0, "Defeats": 7.0, "MostKillsInAGame": 3.0, "MostDamagePlayerInAGame": 202.35869216918945, "MostHeadShotsInAGame": 1.0, "MostGroggiesInAGame": 1.0, "MostDefeatsInAGame": 3.0, "LongestDefeat": 133.34872436523438, "LongRangeDefeats": 1.0, "HeadShots": 2.0, "Groggies": 4.0]), "Mosin": PubgStats.WeaponSummaryDTO(xpTotal: 44571, levelCurrent: 14, tierCurrent: 2, statsTotal: ["LongRangeDefeats": 8.0, "MostGroggiesInAGame": 3.0, "MostKillsInAGame": 4.0, "HeadShots": 2.0, "Kills": 12.0, "MostDefeatsInAGame": 5.0, "MostDamagePlayerInAGame": 266.7971649169922, "LongestDefeat": 257.6938781738281, "MostHeadShotsInAGame": 1.0, "Groggies": 8.0, "DamagePlayer": 1148.4493007659912, "Defeats": 13.0]), "Saiga12": PubgStats.WeaponSummaryDTO(xpTotal: 331, levelCurrent: 1, tierCurrent: 1, statsTotal: ["LongestDefeat": 0.0, "LongRangeDefeats": 0.0, "MostDefeatsInAGame": 0.0, "DamagePlayer": 36.62502098083496, "MostKillsInAGame": 0.0, "MostHeadShotsInAGame": 0.0, "MostDamagePlayerInAGame": 36.62502098083496, "HeadShots": 0.0, "MostGroggiesInAGame": 0.0, "Groggies": 0.0, "Kills": 0.0, "Defeats": 0.0]), "AK47": PubgStats.WeaponSummaryDTO(xpTotal: 20547, levelCurrent: 9, tierCurrent: 1, statsTotal: ["Kills": 6.0, "MostDefeatsInAGame": 1.0, "MostHeadShotsInAGame": 1.0, "MostGroggiesInAGame": 1.0, "Groggies": 5.0, "LongestDefeat": 81.57595825195312, "LongRangeDefeats": 0.0, "MostKillsInAGame": 1.0, "MostDamagePlayerInAGame": 172.33592224121094, "HeadShots": 4.0, "Defeats": 6.0, "DamagePlayer": 945.1682586669922]), "Mini14": PubgStats.WeaponSummaryDTO(xpTotal: 4513, levelCurrent: 2, tierCurrent: 1, statsTotal: ["LongRangeDefeats": 0.0, "Groggies": 0.0, "LongestDefeat": 0.0, "MostHeadShotsInAGame": 1.0, "HeadShots": 1.0, "Defeats": 0.0, "MostDamagePlayerInAGame": 49.70249557495117, "MostKillsInAGame": 0.0, "MostGroggiesInAGame": 0.0, "MostDefeatsInAGame": 0.0, "Kills": 0.0, "DamagePlayer": 147.0065212249756]), "UZI": PubgStats.WeaponSummaryDTO(xpTotal: 1468, levelCurrent: 1, tierCurrent: 1, statsTotal: ["LongestDefeat": 2.272700786590576, "Defeats": 1.0, "MostKillsInAGame": 1.0, "MostDefeatsInAGame": 1.0, "Kills": 1.0, "MostGroggiesInAGame": 0.0, "HeadShots": 0.0, "MostDamagePlayerInAGame": 63.80004692077637, "LongRangeDefeats": 0.0, "DamagePlayer": 63.80004692077637, "Groggies": 0.0, "MostHeadShotsInAGame": 0.0]), "BerylM762": PubgStats.WeaponSummaryDTO(xpTotal: 10197, levelCurrent: 5, tierCurrent: 1, statsTotal: ["MostGroggiesInAGame": 1.0, "MostDefeatsInAGame": 1.0, "MostDamagePlayerInAGame": 106.47763061523438, "Defeats": 3.0, "HeadShots": 1.0, "MostHeadShotsInAGame": 1.0, "Kills": 2.0, "Groggies": 2.0, "MostKillsInAGame": 1.0, "LongRangeDefeats": 0.0, "LongestDefeat": 40.20097351074219, "DamagePlayer": 411.32578468322754]), "SCAR-L": PubgStats.WeaponSummaryDTO(xpTotal: 61130, levelCurrent: 17, tierCurrent: 2, statsTotal: ["LongestDefeat": 103.39547729492188, "Defeats": 18.0, "MostGroggiesInAGame": 2.0, "LongRangeDefeats": 1.0, "Kills": 15.0, "MostKillsInAGame": 2.0, "DamagePlayer": 1521.5067920684814, "MostDamagePlayerInAGame": 201.6399974822998, "MostHeadShotsInAGame": 1.0, "MostDefeatsInAGame": 2.0, "HeadShots": 7.0, "Groggies": 15.0]), "QBZ95": PubgStats.WeaponSummaryDTO(xpTotal: 4800, levelCurrent: 2, tierCurrent: 1, statsTotal: ["MostGroggiesInAGame": 2.0, "LongestDefeat": 14.247783660888672, "MostHeadShotsInAGame": 1.0, "Groggies": 2.0, "LongRangeDefeats": 0.0, "HeadShots": 1.0, "MostDefeatsInAGame": 2.0, "MostDamagePlayerInAGame": 128.7150001525879, "DamagePlayer": 250.153076171875, "Kills": 0.0, "MostKillsInAGame": 0.0, "Defeats": 2.0]), "Thompson": PubgStats.WeaponSummaryDTO(xpTotal: 10865, levelCurrent: 5, tierCurrent: 1, statsTotal: ["HeadShots": 2.0, "Defeats": 5.0, "MostKillsInAGame": 1.0, "MostDefeatsInAGame": 1.0, "MostHeadShotsInAGame": 1.0, "DamagePlayer": 386.6249942779541, "Kills": 4.0, "LongRangeDefeats": 0.0, "Groggies": 1.0, "LongestDefeat": 77.42904663085938, "MostDamagePlayerInAGame": 99.99999809265137, "MostGroggiesInAGame": 1.0]), "G36C": PubgStats.WeaponSummaryDTO(xpTotal: 374, levelCurrent: 1, tierCurrent: 1, statsTotal: ["MostHeadShotsInAGame": 0.0, "MostDamagePlayerInAGame": 20.275686264038086, "Defeats": 0.0, "MostDefeatsInAGame": 0.0, "DamagePlayer": 20.275686264038086, "LongRangeDefeats": 0.0, "LongestDefeat": 0.0, "Kills": 0.0, "Groggies": 0.0, "MostGroggiesInAGame": 0.0, "HeadShots": 0.0, "MostKillsInAGame": 0.0]), "Winchester": PubgStats.WeaponSummaryDTO(xpTotal: 1860, levelCurrent: 1, tierCurrent: 1, statsTotal: ["MostHeadShotsInAGame": 0.0, "MostDamagePlayerInAGame": 52.41249370574951, "MostDefeatsInAGame": 1.0, "LongRangeDefeats": 0.0, "MostGroggiesInAGame": 1.0, "Defeats": 1.0, "HeadShots": 0.0, "Groggies": 1.0, "MostKillsInAGame": 1.0, "Kills": 1.0, "LongestDefeat": 3.4394400119781494, "DamagePlayer": 95.73331212997437]), "M24": PubgStats.WeaponSummaryDTO(xpTotal: 2485, levelCurrent: 1, tierCurrent: 1, statsTotal: ["MostDamagePlayerInAGame": 100.0, "DamagePlayer": 100.0, "MostKillsInAGame": 1.0, "Defeats": 1.0, "MostDefeatsInAGame": 1.0, "Kills": 1.0, "MostGroggiesInAGame": 1.0, "Groggies": 1.0, "LongestDefeat": 1.5797479152679443, "MostHeadShotsInAGame": 0.0, "LongRangeDefeats": 0.0, "HeadShots": 0.0]), "SKS": PubgStats.WeaponSummaryDTO(xpTotal: 16716, levelCurrent: 7, tierCurrent: 1, statsTotal: ["MostKillsInAGame": 2.0, "MostHeadShotsInAGame": 0.0, "Groggies": 3.0, "MostGroggiesInAGame": 2.0, "LongestDefeat": 139.79966735839844, "HeadShots": 0.0, "MostDamagePlayerInAGame": 205.31912803649902, "Defeats": 6.0, "LongRangeDefeats": 3.0, "DamagePlayer": 521.5568180084229, "MostDefeatsInAGame": 2.0, "Kills": 6.0]), "HK416": PubgStats.WeaponSummaryDTO(xpTotal: 8283, levelCurrent: 4, tierCurrent: 1, statsTotal: ["MostHeadShotsInAGame": 1.0, "MostKillsInAGame": 1.0, "MostDamagePlayerInAGame": 143.9099998474121, "MostDefeatsInAGame": 1.0, "MostGroggiesInAGame": 1.0, "DamagePlayer": 535.1668100357056, "Groggies": 1.0, "LongRangeDefeats": 0.0, "LongestDefeat": 13.040318489074707, "HeadShots": 1.0, "Kills": 1.0, "Defeats": 1.0]), "M249": PubgStats.WeaponSummaryDTO(xpTotal: 8875, levelCurrent: 4, tierCurrent: 1, statsTotal: ["MostGroggiesInAGame": 1.0, "MostDefeatsInAGame": 1.0, "MostHeadShotsInAGame": 1.0, "MostKillsInAGame": 1.0, "HeadShots": 2.0, "Groggies": 1.0, "Defeats": 2.0, "LongRangeDefeats": 0.0, "MostDamagePlayerInAGame": 100.0, "DamagePlayer": 273.3549337387085, "LongestDefeat": 33.304840087890625, "Kills": 2.0]), "VSS": PubgStats.WeaponSummaryDTO(xpTotal: 5275, levelCurrent: 3, tierCurrent: 1, statsTotal: ["MostDefeatsInAGame": 1.0, "HeadShots": 0.0, "MostDamagePlayerInAGame": 100.0, "DamagePlayer": 117.83873748779297, "MostHeadShotsInAGame": 0.0, "Kills": 2.0, "Groggies": 2.0, "MostKillsInAGame": 1.0, "Defeats": 2.0, "LongRangeDefeats": 1.0, "LongestDefeat": 123.3236312866211, "MostGroggiesInAGame": 1.0]), "Vector": PubgStats.WeaponSummaryDTO(xpTotal: 5063, levelCurrent: 3, tierCurrent: 1, statsTotal: ["MostKillsInAGame": 0.0, "HeadShots": 3.0, "MostDefeatsInAGame": 0.0, "Kills": 0.0, "Groggies": 0.0, "LongestDefeat": 0.0, "MostGroggiesInAGame": 0.0, "DamagePlayer": 270.147292137146, "Defeats": 0.0, "LongRangeDefeats": 0.0, "MostHeadShotsInAGame": 2.0, "MostDamagePlayerInAGame": 68.35499572753906]), "FNFal": PubgStats.WeaponSummaryDTO(xpTotal: 40266, levelCurrent: 13, tierCurrent: 2, statsTotal: ["HeadShots": 1.0, "Groggies": 9.0, "MostDamagePlayerInAGame": 178.04389572143555, "MostDefeatsInAGame": 4.0, "MostKillsInAGame": 4.0, "Kills": 12.0, "Defeats": 12.0, "LongestDefeat": 344.62530517578125, "MostGroggiesInAGame": 3.0, "LongRangeDefeats": 7.0, "DamagePlayer": 1171.0503768920898, "MostHeadShotsInAGame": 1.0]), "M1911": PubgStats.WeaponSummaryDTO(xpTotal: 3025, levelCurrent: 2, tierCurrent: 1, statsTotal: ["MostHeadShotsInAGame": 0.0, "Defeats": 1.0, "MostKillsInAGame": 1.0, "LongRangeDefeats": 0.0, "Kills": 1.0, "LongestDefeat": 3.0104198455810547, "Groggies": 1.0, "MostDefeatsInAGame": 1.0, "MostDamagePlayerInAGame": 100.0, "MostGroggiesInAGame": 1.0, "DamagePlayer": 100.0, "HeadShots": 0.0]), "Berreta686": PubgStats.WeaponSummaryDTO(xpTotal: 4453, levelCurrent: 2, tierCurrent: 1, statsTotal: ["Kills": 3.0, "LongestDefeat": 7.3974785804748535, "Defeats": 3.0, "MostDefeatsInAGame": 3.0, "MostHeadShotsInAGame": 0.0, "LongRangeDefeats": 0.0, "Groggies": 2.0, "DamagePlayer": 230.89324235916138, "MostGroggiesInAGame": 2.0, "MostKillsInAGame": 3.0, "HeadShots": 0.0, "MostDamagePlayerInAGame": 213.98987102508545]), "MP5K": PubgStats.WeaponSummaryDTO(xpTotal: 1143, levelCurrent: 1, tierCurrent: 1, statsTotal: ["HeadShots": 1.0, "MostDefeatsInAGame": 0.0, "Groggies": 0.0, "MostGroggiesInAGame": 0.0, "LongRangeDefeats": 0.0, "DamagePlayer": 41.579994201660156, "LongestDefeat": 0.0, "MostDamagePlayerInAGame": 41.579994201660156, "Defeats": 0.0, "Kills": 0.0, "MostKillsInAGame": 0.0, "MostHeadShotsInAGame": 1.0]), "Mk47Mutant": PubgStats.WeaponSummaryDTO(xpTotal: 2621, levelCurrent: 2, tierCurrent: 1, statsTotal: ["MostKillsInAGame": 1.0, "HeadShots": 0.0, "LongestDefeat": 151.7778778076172, "MostGroggiesInAGame": 0.0, "Defeats": 1.0, "MostDamagePlayerInAGame": 26.46000099182129, "MostDefeatsInAGame": 1.0, "DamagePlayer": 72.9609260559082, "Kills": 1.0, "Groggies": 0.0, "LongRangeDefeats": 1.0, "MostHeadShotsInAGame": 0.0]), "M16A4": PubgStats.WeaponSummaryDTO(xpTotal: 10704, levelCurrent: 5, tierCurrent: 1, statsTotal: ["MostDamagePlayerInAGame": 150.30999946594238, "MostHeadShotsInAGame": 1.0, "Groggies": 0.0, "MostGroggiesInAGame": 0.0, "Kills": 1.0, "MostKillsInAGame": 1.0, "HeadShots": 2.0, "DamagePlayer": 444.81943702697754, "MostDefeatsInAGame": 1.0, "LongRangeDefeats": 0.0, "LongestDefeat": 44.954193115234375, "Defeats": 1.0]), "Kar98k": PubgStats.WeaponSummaryDTO(xpTotal: 49067, levelCurrent: 15, tierCurrent: 2, statsTotal: ["Defeats": 10.0, "Kills": 9.0, "LongRangeDefeats": 7.0, "MostDefeatsInAGame": 2.0, "MostHeadShotsInAGame": 1.0, "HeadShots": 2.0, "Groggies": 7.0, "DamagePlayer": 1637.1437063217163, "MostDamagePlayerInAGame": 307.65329360961914, "MostKillsInAGame": 2.0, "LongestDefeat": 257.49542236328125, "MostGroggiesInAGame": 2.0]), "Mk12": PubgStats.WeaponSummaryDTO(xpTotal: 11924, levelCurrent: 5, tierCurrent: 1, statsTotal: ["MostDefeatsInAGame": 4.0, "MostKillsInAGame": 3.0, "MostGroggiesInAGame": 4.0, "DamagePlayer": 235.82744789123535, "HeadShots": 1.0, "Groggies": 4.0, "Kills": 3.0, "LongestDefeat": 215.9315185546875, "Defeats": 4.0, "MostDamagePlayerInAGame": 235.82744789123535, "LongRangeDefeats": 1.0, "MostHeadShotsInAGame": 1.0])])))
 */
