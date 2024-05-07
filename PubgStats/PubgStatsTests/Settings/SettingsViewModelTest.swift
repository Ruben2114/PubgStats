//
//  SettingsViewModelTest.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 29/4/24.
//

@testable import PubgStats
import XCTest

final class SettingsViewModelTest: XCTestCase {
    private var dependencies: TestSettingsDependencies!
    private var sut: SettingsViewModel!
    
    override func setUp() {
        super.setUp()
        dependencies = TestSettingsDependencies()
        sut = SettingsViewModel(dependencies: dependencies)
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
        sut = nil
    }
    
    func test_SettingsViewModel_shouldBeDeallocatedCorrectly() {
        XCAssertDeallocation(given: dependencies.viewModel)
    }
    
    func test_SettingsViewModel_When_goToHelp_Then_goHelpCalled() throws {
        XCTAssertFalse(dependencies.coordinatorSpy.goToHelp)
        sut.goHelp()
        XCTAssertTrue(dependencies.coordinatorSpy.goToHelp)
    }
    
    func test_SettingsViewModel_When_viewDidLoad_Then_showFields() {
        dependencies.shouldUseMockSettingsDataUseCase = true
        XCTAssertForPublisher(sut.state,
                              assert: { state in
            switch state {
            case .showFields(let field):
                return !field.isEmpty
            default:
                return false
            }
        },beforeWait: { [weak self] in
            self?.sut.viewDidLoad()
        })
    }
    
    func test_SettingsViewModel_When_deleteProfile_Then_ErrorService() {
        dependencies.shouldUseMockSettingsDataUseCase = true
        dependencies.deleteProfileError = true
        XCTAssertForPublisher(sut.state,
                              assert: { state in
            switch state {
            case .showErrorDelete:
                return true
            default:
                return false
            }
        },beforeWait: { [weak self] in
            self?.sut.viewDidLoad()
            self?.sut.deleteProfile()
        })
    }
    
    func test_SettingsViewModel_When_deleteProfile_Then_goDeleteProfile() {
        dependencies.shouldUseMockSettingsDataUseCase = true
        XCTAssertFalse(dependencies.coordinatorSpy.goToHelp)
        sut.viewDidLoad()
        sut.deleteProfile()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            XCTAssertTrue(self?.dependencies.coordinatorSpy.goToHelp ?? false)
        }
    }
}

extension SettingsViewModel: SceneViewModel {}
