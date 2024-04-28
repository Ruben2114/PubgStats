//
//  FavouriteViewControllerTest.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 28/4/24.
//

@testable import PubgStats
import XCTest

final class FavouriteViewControllerTest: XCTestCase {
    private var dependencies: TestFavouriteDependencies!
    
    override func setUp() {
        super.setUp()
        dependencies = TestFavouriteDependencies()
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
    }
    
    func test_FavouriteViewController_shouldBeDeallocatedCorrectly() {
        XCAssertDeallocation(given: retrieveViewController, timeout: 5.0)
    }
}

private extension FavouriteViewControllerTest {
    func retrieveViewController() -> UIViewController {
        let viewController: FavouriteViewController = dependencies.resolve()
        return viewController
    }
}
