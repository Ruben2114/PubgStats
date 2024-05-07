//
//  SettingsViewControllerTest.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 29/4/24.
//

@testable import PubgStats
import XCTest

final class SettingsViewControllerTest: XCTestCase {
    private var dependencies: SettingsDependencies!
    
    override func setUp() {
        super.setUp()
        dependencies = TestSettingsDependencies()
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
    }
    
    func test_SettingsViewController_shouldBeDeallocatedCorrectly() {
        XCAssertDeallocation(given: retrieveViewController, timeout: 5.0)
    }
}

private extension SettingsViewControllerTest {
    func retrieveViewController() -> UIViewController {
        let viewController: SettingsViewController = dependencies.resolve()
        return viewController
    }
}
