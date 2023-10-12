//
//  LoginViewModelTest.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 12/10/23.
//

@testable import PubgStats
import XCTest

final class LoginViewModelTest: XCTestCase {
    private var dependencies: TestLoginDependency!
    private var sut: LoginViewModel!
    
    override func setUp() {
        super.setUp()
        dependencies = TestLoginDependency()
        sut = LoginViewModel(dependencies: dependencies)
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
        sut = nil
    }
    
    func test_LoginViewModel_shouldBeDeallocatedCorrectly() {
        XCAssertDeallocation(given: dependencies.viewModel)
    }
    
    func test_LoginViewModel_When_goToProfile_Then_goToProfileCalled() throws {
        XCTAssertFalse(dependencies.coordinatorSpy.goToProfileCalled)
        sut.goToProfile(player: "", id: "")
        XCTAssertTrue(dependencies.coordinatorSpy.goToProfileCalled)
    }
    
}

extension LoginViewModel: SceneViewModel {}
