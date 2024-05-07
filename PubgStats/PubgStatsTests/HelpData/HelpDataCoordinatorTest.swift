//
//  HelpDataCoordinatorTest.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 29/4/24.
//

@testable import PubgStats
import XCTest

final class HelpDataCoordinatorTest: XCTestCase {
    var navigationController: UINavigationController!
    
    override func setUp() {
        super.setUp()
        navigationController = UINavigationController()
    }
    
    override func tearDown() {
        super.tearDown()
        navigationController = nil
    }
    
    func test_HelpDataCoordinator_shouldBeDeallocatedCorrectly() {
        XCAssertDeallocation { HelpDataCoordinatorImp(dependencies: TestHelpDataExternalDependencies(), navigation: navigationController) }
    }
}
