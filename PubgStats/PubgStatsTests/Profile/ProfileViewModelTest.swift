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
    
    func test_ProfileViewModel_When_goToSurvival_Then_goToAttributesDetailssCalled() throws {
        XCTAssertFalse(dependencies.coordinatorSpy.goToAttributesDetails)
        sut.goToSurvival()
        XCTAssertTrue(dependencies.coordinatorSpy.goToAttributesDetails)
    }
    
    func test_ProfileViewModel_When_goToMatches_Then_goToMatchesCalled() throws {
        XCTAssertFalse(dependencies.coordinatorSpy.goToMatches)
        sut.goToMatches()
        XCTAssertTrue(dependencies.coordinatorSpy.goToMatches)
    }
    
    func test_ProfileViewModel_When_goToWeb_Then_goToWebCalled() throws {
        XCTAssertFalse(dependencies.coordinatorSpy.goToWeb)
        sut.goToWeb(urlString: .news)
        XCTAssertTrue(dependencies.coordinatorSpy.goToWeb)
    }
    
    func test_ProfileViewModel_When_goBack_Then_goBackCalled() throws {
        XCTAssertFalse(dependencies.coordinatorSpy.goToBack)
        sut.backButton()
        XCTAssertTrue(dependencies.coordinatorSpy.goToBack)
    }
    
    func test_ProfileViewModel_When_getPlayerDetails_Then_ErrorService() {
        dependencies.shouldUseMockProfileDataUseCase = true
        dependencies.playerDataError = true
        XCTAssertForPublisher(sut.state,
                              assert: { state in
            switch state {
            case .showErrorPlayerDetails:
                return true
            default:
                return false
            }
        },beforeWait: { [weak self] in
            self?.sut.viewDidLoad()
        })
    }
    
    func test_ProfileViewModel_When_getPlayerDetails_Then_getDetails() {
        dependencies.shouldUseMockProfileDataUseCase = true
        XCTAssertForPublisher(sut.state,
                              assert: { state in
            switch state {
            case .showHeader(let info):
                return info.level == "1" && info.xp == "10" ? true : false
            default:
                return false
            }
        },beforeWait: { [weak self] in
            self?.sut.viewDidLoad()
        })
    }
}

extension ProfileViewModel: SceneViewModel {}
