//
//  WeaponDataDetailDependency.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 28/3/23.
//

protocol WeaponDataDetailDependency {
    var external: WeaponDataDetailExternalDependency { get }
    func resolve() -> WeaponDataDetailCoordinator?
    func resolve() -> WeaponDataDetailViewController
    func resolve() -> WeaponDataDetailViewModel
    func resolve() -> WeaponDataDetailUseCase
    func resolve() -> WeaponDataDetailRepository
}

extension WeaponDataDetailDependency {
    func resolve() -> WeaponDataDetailViewController {
        WeaponDataDetailViewController(dependencies: self)
    }
    func resolve() -> WeaponDataDetailViewModel {
        WeaponDataDetailViewModel(dependencies: self)
    }
    func resolve() -> WeaponDataDetailUseCase {
        WeaponDataDetailUseCaseImp(dependencies: self)
    }
    func resolve() -> WeaponDataDetailRepository {
        WeaponDataDetailRepositoryImp(dependencies: self)
    }
}
