//
//  FavouriteDataUseCaseTest.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 29/4/24.
//

import XCTest
@testable import PubgStats
import Foundation

final class FavouriteDataUseCaseTest: XCTestCase {
    private var dependencies: TestFavouriteDependencies!
    
    override func setUp() {
        super.setUp()
        dependencies = TestFavouriteDependencies()
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
    }
    
    func test_Given_FavouriteDataUseCase_When_fetchPlayerData_Then_NotFail() throws {
        let useCase: FavouriteDataUseCase = dependencies.resolve()
        let _ = useCase.fetchPlayerData(name: "name", platform: "steam").map { data in
            XCTAssertTrue(data.id == "1111")
        }.eraseToAnyPublisher()
    }
    
    func test_Given_FavouriteDataUseCase_When_fetchPlayerData_Then_Fail() throws {
        let useCase: FavouriteDataUseCase = dependencies.resolve()
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
    
    func test_Given_FavouriteDataUseCase_When_getFavouritesPlayers_Then_NotFail() throws {
        let useCase: FavouriteDataUseCase = dependencies.resolve()
        let _ = useCase.getFavouritesPlayers().map { data in
            let assert: Bool = data.first?.name == "name" &&
            data.first?.id == "1111" &&
            data.first?.platform == "steam"
            XCTAssertTrue(assert)
        }.eraseToAnyPublisher()
    }
    
    func test_Given_FavouriteDataUseCase_When_deleteFavouritePlayer_Then_Fail() throws {
        let useCase: FavouriteDataUseCase = dependencies.resolve()
        let _ = useCase.deleteFavouritePlayer(MockIdAccountDataProfile(id: "", name: "", platform: ""))
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
