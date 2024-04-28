//
//  LoginViewModelTest.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 12/10/23.
//

@testable import PubgStats
import XCTest

final class LoginViewModelTest: XCTestCase {
    private var dependencies: TestLoginDependencies!
    private var sut: LoginViewModel!
    
    override func setUp() {
        super.setUp()
        dependencies = TestLoginDependencies()
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
        sut.goToProfile(data: DefaultIdAccountDataProfile(id: "", name: "", platform: ""))
        XCTAssertTrue(dependencies.coordinatorSpy.goToProfileCalled)
    }
    
    func test_LoginViewModel_When_CheckPlayer_Then_ErrorService() {
        dependencies.shouldUseMockLoginDataUseCase = true
        dependencies.playerDataError = true
        XCTAssertForPublisher(sut.state.filter { $0 == .sendInfoProfileError},
                              assert: {_ in true },
                              beforeWait: { [weak self] in
            self?.sut.viewDidLoad()
            self?.sut.checkPlayer(player: "A", platform: "steam")
        })
    }
}

extension LoginViewModel: SceneViewModel {}
