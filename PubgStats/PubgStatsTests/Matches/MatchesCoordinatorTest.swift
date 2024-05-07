//
//  MatchesCoordinatorTest.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 27/4/24.
//

@testable import PubgStats
import XCTest

final class MatchesCoordinatorTest: XCTestCase {
    var navigationController: UINavigationController!
    
    override func setUp() {
        super.setUp()
        navigationController = UINavigationController()
    }
    
    override func tearDown() {
        super.tearDown()
        navigationController = nil
    }
    
    func test_MatchesCoordinator_shouldBeDeallocatedCorrectly() {
        XCAssertDeallocation { MatchesCoordinatorImp(dependencies: TestMatchesExternalDependencies(), navigation: navigationController) }
    }
}
