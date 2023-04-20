//
//  WeaponDataDetailUseCase.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 12/4/23.
//

protocol WeaponDataDetailUseCase {
    func getDataWeaponDetail(for sessionUser: ProfileEntity, type: NavigationStats) -> [Weapon]?
}

struct WeaponDataDetailUseCaseImp: WeaponDataDetailUseCase {
    private let weaponDataDetailRepository: WeaponDataDetailRepository
    init(dependencies: WeaponDataDetailDependency) {
        self.weaponDataDetailRepository = dependencies.resolve()
    }
    func getDataWeaponDetail(for sessionUser: ProfileEntity, type: NavigationStats) -> [Weapon]? {
        weaponDataDetailRepository.getDataWeaponDetail(for: sessionUser, type: type)
    }
}
