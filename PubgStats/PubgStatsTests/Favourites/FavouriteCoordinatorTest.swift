//
//  FavouriteCoordinatorTest.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 28/4/24.
//

@testable import PubgStats
import XCTest

final class FavouriteCoordinatorTest: XCTestCase {
    var navigationController: UINavigationController!
    
    override func setUp() {
        super.setUp()
        navigationController = UINavigationController()
    }
    
    override func tearDown() {
        super.tearDown()
        navigationController = nil
    }
    
    func test_FavouriteCoordinator_shouldBeDeallocatedCorrectly() {
        XCAssertDeallocation { FavouriteCoordinatorImp(dependencies: TestFavouriteExternalDependencies(), navigation: navigationController) }
    }
}
