//
//  WeaponDataDependency.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 27/3/23.
//

protocol WeaponDataDependency {
    var external: WeaponDataExternalDependency { get }
    func resolve() -> WeaponDataCoordinator?
    func resolve() -> WeaponDataViewController
    func resolve() -> WeaponDataViewModel
    func resolve() -> WeaponDataUseCase
}

extension WeaponDataDependency {
    func resolve() -> WeaponDataViewController {
        WeaponDataViewController(dependencies: self)
    }
    func resolve() -> WeaponDataViewModel {
        WeaponDataViewModel(dependencies: self)
    }
    func resolve() -> WeaponDataUseCase {
        let remoteData = AppContainerImp().remoteDataService
        let weaponDataRepository = WeaponDataRepositoryImp(remoteData: remoteData)
        let weaponDataUseCase = WeaponDataUseCaseImp(weaponDataRepository: weaponDataRepository)
        return weaponDataUseCase
    }
}
