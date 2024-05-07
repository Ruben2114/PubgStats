//
//  TestFavouriteDependencies.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 28/4/24.
//

@testable import PubgStats

final class TestFavouriteDependencies: FavouriteDependencies {
    var external: FavouriteExternalDependencies
    let coordinatorSpy = FavouriteCoordinatorSpy()
    let mockFavouriteDataUseCase = MockFavouriteDataUseCase()
    var shouldUseMockFavouriteDataUseCase = false
    var favouritesDataError = false
    var newFavouritesDataError = false
    var deleteFavouritesDataError = false
    
    init() {
        self.external = TestFavouriteExternalDependencies()
    }
    
    func viewModel() -> FavouriteViewModel {
        resolve()
    }
    
    func resolve() -> DataBinding {
        DataBindingObject()
    }
    
    func resolve() -> FavouriteCoordinator {
        coordinatorSpy
    }
    
    func resolve() -> FavouriteDataUseCase {
        if shouldUseMockFavouriteDataUseCase {
            mockFavouriteDataUseCase.favouritesDataError = favouritesDataError
            mockFavouriteDataUseCase.newFavouritesDataError = newFavouritesDataError
            mockFavouriteDataUseCase.deleteFavouritesDataError = deleteFavouritesDataError
            return mockFavouriteDataUseCase
        } else {
            return FavouriteDataUseCaseImp(dependencies: self)
        }
    }
}
