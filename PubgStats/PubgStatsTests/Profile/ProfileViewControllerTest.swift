//
//  ProfileViewControllerTest.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 19/2/24.
//

import Foundation
@testable import PubgStats
import XCTest

final class ProfileViewControllerTest: XCTestCase {
    private var dependencies: TestProfileDependencies!
    
    override func setUp() {
        super.setUp()
        dependencies = TestProfileDependencies()
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
    }
    
    func test_ProfileViewController_shouldBeDeallocatedCorrectly() {
        XCAssertDeallocation(given: retrieveViewController, timeout: 5.0)
    }
}

private extension ProfileViewControllerTest {
    func retrieveViewController() -> UIViewController {
        let viewController: ProfileViewController = dependencies.resolve()
        return viewController
    }
}
