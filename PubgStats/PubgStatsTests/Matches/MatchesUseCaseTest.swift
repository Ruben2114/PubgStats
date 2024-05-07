//
//  MatchesUseCaseTest.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 28/4/24.
//

import XCTest
@testable import PubgStats
import Foundation

final class MatchesUseCaseTest: XCTestCase {
    private var dependencies: TestMatchesDependencies!
    
    override func setUp() {
        super.setUp()
        dependencies = TestMatchesDependencies()
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
    }
    
    func test_Given_MatchesUseCaseTest_When_fetchMatches_Then_NotFail() throws {
        let useCase: MatchesDataUseCase = dependencies.resolve()
        let _ = useCase.fetchMatches([], platform: "steam").map { data in
            let assert: Bool = data.first?.type == "rank" &&
            data.first?.id == "1" &&
            data.first?.included.isEmpty == true &&
            data.first?.links == "links"
            XCTAssertTrue(assert)
        }.eraseToAnyPublisher()
    }
    
    func test_Given_MatchesUseCaseTest_When_fetchMatches_Then_Fail() throws {
        let useCase: MatchesDataUseCase = dependencies.resolve()
        let _ = useCase.fetchMatches([], platform: "steam")
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
