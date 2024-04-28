//
//  MatchesViewModelTest.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 27/4/24.
//

@testable import PubgStats
import XCTest

final class MatchesViewModelTest: XCTestCase {
    private var dependencies: TestMatchesDependencies!
    private var sut: MatchesViewModel!
    
    override func setUp() {
        super.setUp()
        dependencies = TestMatchesDependencies()
        sut = MatchesViewModel(dependencies: dependencies)
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
        sut = nil
    }
    
    func test_MatchesViewModel_shouldBeDeallocatedCorrectly() {
        XCAssertDeallocation(given: dependencies.viewModel)
    }
    
    func test_MatchesViewModel_When_backButton_Then_goBackCalled() throws {
        XCTAssertFalse(dependencies.coordinatorSpy.goToBack)
        sut.backButton()
        XCTAssertTrue(dependencies.coordinatorSpy.goToBack)
    }
}

extension MatchesViewModel: SceneViewModel {}
