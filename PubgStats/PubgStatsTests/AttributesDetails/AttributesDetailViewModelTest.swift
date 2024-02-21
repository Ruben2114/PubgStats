//
//  AttributesDetailViewModelTest.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 21/2/24.
//

@testable import PubgStats
import XCTest

final class AttributesDetailViewModelTest: XCTestCase {
    private var dependencies: TestAttributesDetailDependencies!
    private var sut: AttributesDetailViewModel!
    
    override func setUp() {
        super.setUp()
        dependencies = TestAttributesDetailDependencies()
        sut = AttributesDetailViewModel(dependencies: dependencies)
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
        sut = nil
    }
    
    func test_AttributesDetailViewModel_shouldBeDeallocatedCorrectly() {
        XCAssertDeallocation(given: dependencies.viewModel)
    }
    
    func test_AttributesDetailViewModel_When_backButton_Then_goBackCalled() throws {
        XCTAssertFalse(dependencies.coordinatorSpy.goToBack)
        sut.backButton()
        XCTAssertTrue(dependencies.coordinatorSpy.goToBack)
    }
}

extension AttributesDetailViewModel: SceneViewModel {}

