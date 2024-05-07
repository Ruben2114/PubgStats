//
//  ProfileDataUseCaseTest.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 28/4/24.
//

import XCTest
@testable import PubgStats
import Foundation

final class ProfileDataUseCaseTest: XCTestCase {
    private var dependencies: TestProfileDependencies!
    
    override func setUp() {
        super.setUp()
        dependencies = TestProfileDependencies()
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
    }
    
    func test_Given_ProfileDataUseCaseTest_When_fetchPlayerDetails_Then_NotFail() throws {
        let useCase: ProfileDataUseCase = dependencies.resolve()
        let _ = useCase.fetchPlayerDetails(MockIdAccountDataProfile(id: "1111", name: "Leyenda21", platform: "steam"), reload: false, type: .profile).map { data in
            let assert: Bool = data.infoSurvival.xp == "10" &&
            data.infoSurvival.level == "1" &&
            data.infoGamesModes.headshotKillsTotal == 0 &&
            data.infoGamesModes.timePlayed == "timePlayed" &&
            data.infoWeapon.weaponSummaries.isEmpty
            XCTAssertTrue(assert)
        }.eraseToAnyPublisher()
    }
    
    func test_Given_ProfileDataUseCaseTest_When_fetchPlayerDetails_Then_Fail() throws {
        let useCase: ProfileDataUseCase = dependencies.resolve()
        let _ = useCase.fetchPlayerDetails(MockIdAccountDataProfile(id: "", name: "", platform: ""), reload: false, type: .profile)
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
