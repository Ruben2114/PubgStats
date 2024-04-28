//
//  LoginDataUseCaseTest.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 12/10/23.
//

import XCTest
@testable import PubgStats
import Foundation

final class LoginDataUseCaseTest: XCTestCase {
    private var dependencies: TestLoginDependencies!
    
    override func setUp() {
        super.setUp()
        dependencies = TestLoginDependencies()
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
    }
    
    func test_Given_LoginDataUseCaseTest_When_fetchPlayerData_Then_NotFail() throws {
        let useCase: LoginDataUseCase = dependencies.resolve()
        let _ = useCase.fetchPlayerData(name: "Leyenda21", platform: "steam").map{ data in
            XCTAssertTrue(data.id == "1111")
        }.eraseToAnyPublisher()
    }
    
    func test_Given_LoginDataUseCaseTest_When_fetchPlayerData_Then_Fail() throws {
        let useCase: LoginDataUseCase = dependencies.resolve()
        let _ = useCase.fetchPlayerData(name: "", platform: "")
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
