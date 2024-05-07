//
//  ProfileCoordinatorTest.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 19/2/24.
//

@testable import PubgStats
import XCTest

final class ProfileCoordinatorTest: XCTestCase {
    var navigationController: UINavigationController!
    
    override func setUp() {
        super.setUp()
        navigationController = UINavigationController()
    }
    
    override func tearDown() {
        super.tearDown()
        navigationController = nil
    }
    
    func test_ProfileCoordinatorTest_shouldBeDeallocatedCorrectly() {
        XCAssertDeallocation { ProfileCoordinatorImp(dependencies: TestProfileExternalDependencies(), navigation: navigationController) }
    }
}
