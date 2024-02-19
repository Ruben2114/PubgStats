//
//  LoginViewControllerTest.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 19/2/24.
//

import Foundation
@testable import PubgStats
import XCTest

final class LoginViewControllerTest: XCTestCase {
    private var dependencies: TestLoginDependencies!
    
    override func setUp() {
        super.setUp()
        dependencies = TestLoginDependencies()
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
    }
    
    func test_LoginViewController_shouldBeDeallocatedCorrectly() {
        XCAssertDeallocation(given: retrieveViewController, timeout: 5.0)
    }
}

private extension LoginViewControllerTest {
    func retrieveViewController() -> UIViewController {
        let viewController: LoginViewController = dependencies.resolve()
        return viewController
    }
}
