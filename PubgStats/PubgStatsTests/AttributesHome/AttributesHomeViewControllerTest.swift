//
//  AttributesHomeViewControllerTest.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 19/2/24.
//

@testable import PubgStats
import XCTest

final class AttributesHomeViewControllerTest: XCTestCase {
    private var dependencies: TestAttributesHomeDependencies!
    
    override func setUp() {
        super.setUp()
        dependencies = TestAttributesHomeDependencies()
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
    }
    
    func test_AttributesHomeViewController_shouldBeDeallocatedCorrectly() {
        XCAssertDeallocation(given: retrieveViewController, timeout: 5.0)
    }
}

private extension AttributesHomeViewControllerTest {
    func retrieveViewController() -> UIViewController {
        let viewController: AttributesHomeViewController = dependencies.resolve()
        return viewController
    }
}
