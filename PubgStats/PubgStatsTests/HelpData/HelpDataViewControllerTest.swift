//
//  HelpDataViewControllerTest.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 29/4/24.
//

@testable import PubgStats
import XCTest

final class HelpDataViewControllerTest: XCTestCase {
    private var dependencies: HelpDataDependencies!
    
    override func setUp() {
        super.setUp()
        dependencies = TestHelpDataDependencies()
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
    }
    
    func test_HelpDataViewController_shouldBeDeallocatedCorrectly() {
        XCAssertDeallocation(given: retrieveViewController, timeout: 5.0)
    }
}

private extension HelpDataViewControllerTest {
    func retrieveViewController() -> UIViewController {
        let viewController: HelpDataViewController = dependencies.resolve()
        return viewController
    }
}
