//
//  AttributesHomeCoordinatorTest.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 19/2/24.
//

@testable import PubgStats
import XCTest

final class AttributesHomeCoordinatorTest: XCTestCase {
    var navigationController: UINavigationController!
    
    override func setUp() {
        super.setUp()
        navigationController = UINavigationController()
    }
    
    override func tearDown() {
        super.tearDown()
        navigationController = nil
    }
    
    func test_AttributesHomeCoordinatorTest_shouldBeDeallocatedCorrectly() {
        XCAssertDeallocation { AttributesHomeCoordinatorImp(dependencies: TestAttributesHomeExternalDependencies(), navigation: navigationController) }
    }
}
