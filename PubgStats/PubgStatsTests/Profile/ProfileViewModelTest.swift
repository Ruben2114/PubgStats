//
//  ProfileViewModelTest.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 19/2/24.
//

@testable import PubgStats
import XCTest

final class ProfileViewModelTest: XCTestCase {
    private var dependencies: TestProfileDependencies!
    private var sut: ProfileViewModel!
    
    override func setUp() {
        super.setUp()
        dependencies = TestProfileDependencies()
        sut = ProfileViewModel(dependencies: dependencies)
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
        sut = nil
    }
    
    func test_ProfileViewModel_shouldBeDeallocatedCorrectly() {
        XCAssertDeallocation(given: dependencies.viewModel)
    }
    
    func test_ProfileViewModel_When_goToModes_Then_goToAttributesCalled() throws {
        XCTAssertFalse(dependencies.coordinatorSpy.goToAttributes)
        sut.goToModes()
        XCTAssertTrue(dependencies.coordinatorSpy.goToAttributes)
    }
    
    func test_ProfileViewModel_When_goToWeapon_Then_goToAttributesCalled() throws {
        XCTAssertFalse(dependencies.coordinatorSpy.goToAttributes)
        sut.goToWeapon()
        XCTAssertTrue(dependencies.coordinatorSpy.goToAttributes)
    }
    
    func test_ProfileViewModel_When_goToSurvival_Then_goToAttributesCalled() throws {
        XCTAssertFalse(dependencies.coordinatorSpy.goToAttributesDetails)
        sut.goToSurvival()
        XCTAssertTrue(dependencies.coordinatorSpy.goToAttributesDetails)
    }
}

extension ProfileViewModel: SceneViewModel {}
