//
//  AttributesHomeViewModelTest.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 19/2/24.
//

@testable import PubgStats
import XCTest

final class AttributesHomeViewModelTest: XCTestCase {
    private var dependencies: TestAttributesHomeDependencies!
    private var sut: AttributesHomeViewModel!
    
    override func setUp() {
        super.setUp()
        dependencies = TestAttributesHomeDependencies()
        sut = AttributesHomeViewModel(dependencies: dependencies)
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
        sut = nil
    }
    
    func test_AttributesHomeViewModel_shouldBeDeallocatedCorrectly() {
        XCAssertDeallocation(given: dependencies.viewModel)
    }
    
    func test_AttributesHomeViewModel_When_goToAttributesDetails_Then_goToAttributesDetailsCalled() throws {
        XCTAssertFalse(dependencies.coordinatorSpy.goToAttributesDetails)
        sut.goToAttributesDetails(DefaultAttributesHome(title: "",
                                                        percentage: 0,
                                                        image: "",
                                                        type: .survival))
        XCTAssertTrue(dependencies.coordinatorSpy.goToAttributesDetails)
    }
    
    func test_AttributesHomeViewModel_When_backButton_Then_goBackCalled() throws {
        XCTAssertFalse(dependencies.coordinatorSpy.goToBack)
        sut.backButton()
        XCTAssertTrue(dependencies.coordinatorSpy.goToBack)
    }
}

extension AttributesHomeViewModel: SceneViewModel {}
