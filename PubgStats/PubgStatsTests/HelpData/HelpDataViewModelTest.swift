//
//  HelpDataViewModelTest.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 29/4/24.
//

@testable import PubgStats
import XCTest

final class HelpDataViewModelTest: XCTestCase {
    private var dependencies: TestHelpDataDependencies!
    private var sut: HelpDataViewModel!
    
    override func setUp() {
        super.setUp()
        dependencies = TestHelpDataDependencies()
        sut = HelpDataViewModel(dependencies: dependencies)
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
        sut = nil
    }
    
    func test_HelpDataViewModel_When_backButton_Then_goBackCalled() throws {
        XCTAssertFalse(dependencies.coordinatorSpy.goToBack)
        sut.backButton()
        XCTAssertTrue(dependencies.coordinatorSpy.goToBack)
    }
}
