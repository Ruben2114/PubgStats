//
//  TestFavouriteExternalDependencies.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 28/4/24.
//

@testable import PubgStats
import UIKit

final class TestFavouriteExternalDependencies: FavouriteExternalDependencies {
    func resolve() -> FavouritePlayerRepository {
        MockFavouritePlayerRepository()
    }
   
    func profileCoordinator(navigation: UINavigationController?) -> BindableCoordinator {
        fatalError()
    }
    
    func resolve() -> DataPlayerRepository {
        MockDataPlayerRepository()
    }
}
