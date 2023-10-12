//
//  LoginCoordinatorTest.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 12/10/23.
//

import Foundation
@testable import PubgStats
import XCTest

final class LoginCoordinatorTest: XCTestCase {
    var navigationController: UINavigationController!
    
    override func setUp() {
        super.setUp()
        navigationController = UINavigationController()
    }
    
    override func tearDown() {
        super.tearDown()
        navigationController = nil
    }
    
    func test_LoginCoordinatorTest_shouldBeDeallocatedCorrectly() {
        XCAssertDeallocation { LoginCoordinatorImp(dependencies: TestLoginExternalDependency(), navigation: navigationController) }
    }
}

