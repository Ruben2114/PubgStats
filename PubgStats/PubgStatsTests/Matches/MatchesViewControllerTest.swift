//
//  MatchesViewControllerTest.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 27/4/24.
//

@testable import PubgStats
import XCTest

final class MatchesViewControllerTest: XCTestCase {
    private var dependencies: TestMatchesDependencies!
    
    override func setUp() {
        super.setUp()
        dependencies = TestMatchesDependencies()
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
    }
    
    func test_MatchesViewController_shouldBeDeallocatedCorrectly() {
        XCAssertDeallocation(given: retrieveViewController, timeout: 5.0)
    }
}

private extension MatchesViewControllerTest {
    func retrieveViewController() -> UIViewController {
        let viewController: MatchesViewController = dependencies.resolve()
        return viewController
    }
}
