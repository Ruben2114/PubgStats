//
//  AttributesDetailCoordinatorTest.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 21/2/24.
//

@testable import PubgStats
import XCTest

final class AttributesDetailCoordinatorTest: XCTestCase {
    var navigationController: UINavigationController!
    
    override func setUp() {
        super.setUp()
        navigationController = UINavigationController()
    }
    
    override func tearDown() {
        super.tearDown()
        navigationController = nil
    }
    
    func test_AttributesDetailCoordinatorTest_shouldBeDeallocatedCorrectly() {
        XCAssertDeallocation { AttributesDetailCoordinatorImp(dependencies: TestAttributesDetailExternalDependencies(), navigation: navigationController) }
    }
}
