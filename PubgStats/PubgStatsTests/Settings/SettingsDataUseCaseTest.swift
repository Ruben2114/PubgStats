//
//  SettingsDataUseCaseTest.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 29/4/24.
//

import XCTest
@testable import PubgStats
import Foundation

final class SettingsDataUseCaseTest: XCTestCase {
    private var dependencies: SettingsDependencies!
    
    override func setUp() {
        super.setUp()
        dependencies = TestSettingsDependencies()
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
    }
    
    func test_Given_SettingsDataUseCase_When_deleteProfile_Then_Fail() throws {
        let useCase: SettingsDataUseCase = dependencies.resolve()
        let _ = useCase.deleteProfile(profile: MockIdAccountDataProfile(id: "", name: "", platform: ""))
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTAssertTrue(error.localizedDescription == URLError(.badURL).localizedDescription)
                case .finished:
                    break
                }
            } receiveValue: { _ in }
    }
}
