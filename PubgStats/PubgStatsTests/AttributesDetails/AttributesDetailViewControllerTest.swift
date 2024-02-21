//
//  AttributesDetailViewControllerTest.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 21/2/24.
//

@testable import PubgStats
import XCTest

final class AttributesDetailViewControllerTest: XCTestCase {
    private var dependencies: TestAttributesDetailDependencies!
    
    override func setUp() {
        super.setUp()
        dependencies = TestAttributesDetailDependencies()
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
    }
    
    func test_AttributesDetailViewController_shouldBeDeallocatedCorrectly() {
        XCAssertDeallocation(given: retrieveViewController, timeout: 5.0)
    }
}

private extension AttributesDetailViewControllerTest {
    func retrieveViewController() -> UIViewController {
        let viewController: AttributesDetailViewController = dependencies.resolve()
        return viewController
    }
}
