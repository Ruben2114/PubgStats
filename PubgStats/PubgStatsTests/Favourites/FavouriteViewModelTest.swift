//
//  FavouriteViewModelTest.swift
//  PubgStatsTests
//
//  Created by Ruben Rodriguez on 28/4/24.
//

@testable import PubgStats
import XCTest

final class FavouriteViewModelTest: XCTestCase {
    private var dependencies: TestFavouriteDependencies!
    private var sut: FavouriteViewModel!
    
    override func setUp() {
        super.setUp()
        dependencies = TestFavouriteDependencies()
        sut = FavouriteViewModel(dependencies: dependencies)
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
        sut = nil
    }
    
    func test_FavouriteViewModel_shouldBeDeallocatedCorrectly() {
        XCAssertDeallocation(given: dependencies.viewModel)
    }
    
    func test_FavouriteViewModel_When_backButton_Then_goBackCalled() throws {
        XCTAssertFalse(dependencies.coordinatorSpy.goToProfile)
        sut.goToProfile(MockIdAccountDataProfile(id: "", name: "", platform: ""))
        XCTAssertTrue(dependencies.coordinatorSpy.goToProfile)
    }
    
    func test_FavouriteViewModel_When_getFavouritesSubject_Then_ErrorService() {
        dependencies.shouldUseMockFavouriteDataUseCase = true
        dependencies.favouritesDataError = true
        XCTAssertForPublisher(sut.state,
                              assert: { state in
            switch state {
            case .showError:
                return true
            default:
                return false
            }
        },beforeWait: { [weak self] in
            self?.sut.viewDidLoad()
        })
    }
    
    func test_FavouriteViewModel_When_getFavouritesSubject_Then_getFavourites() {
        dependencies.shouldUseMockFavouriteDataUseCase = true
        XCTAssertForPublisher(sut.state,
                              assert: { state in
            switch state {
            case .showPlayerDetails(let players):
                return players.first?.name == "name" &&
                players.first?.platform == "steam" &&
                players.first?.id == "1111"
            default:
                return false
            }
        },beforeWait: { [weak self] in
            self?.sut.viewDidLoad()
        })
    }
    
    func test_FavouriteViewModel_When_searchFavourite_Then_ErrorService() {
        dependencies.shouldUseMockFavouriteDataUseCase = true
        dependencies.newFavouritesDataError = true
        XCTAssertForPublisher(sut.state,
                              assert: { state in
            switch state {
            case .showError:
                return true
            default:
                return false
            }
        },beforeWait: { [weak self] in
            self?.sut.viewDidLoad()
            self?.sut.searchFavourite(name: "newName", platform: "steam")
        })
    }
    
    func test_FavouriteViewModel_When_searchFavourite_Then_newFavourites() {
        dependencies.shouldUseMockFavouriteDataUseCase = true
        dependencies.favouritesDataError = true
        XCTAssertForPublisher(sut.state,
                              assert: { state in
            switch state {
            case .showPlayerDetails(let players):
                return players.first?.id == "1111"
            default:
                return false
            }
        },beforeWait: { [weak self] in
            self?.sut.viewDidLoad()
            self?.sut.searchFavourite(name: "newName", platform: "steam")
        })
    }
    
    func test_FavouriteViewModel_When_deleteFavourite_Then_ErrorService() {
        dependencies.shouldUseMockFavouriteDataUseCase = true
        dependencies.deleteFavouritesDataError = true
        XCTAssertForPublisher(sut.state,
                              assert: { state in
            switch state {
            case .showError:
                return true
            default:
                return false
            }
        },beforeWait: { [weak self] in
            self?.sut.viewDidLoad()
            self?.sut.deleteFavourite(MockIdAccountDataProfile(id: "1111", name: "name", platform: "steam"))
        })
    }
    
    func test_FavouriteViewModel_When_deleteFavourite_Then_deleteFavourite() {
        dependencies.shouldUseMockFavouriteDataUseCase = true
        XCTAssertForPublisher(sut.state,
                              assert: { state in
            switch state {
            case .deletePlayer:
                return true
            default:
                return false
            }
        },beforeWait: { [weak self] in
            self?.sut.viewDidLoad()
            self?.sut.deleteFavourite(MockIdAccountDataProfile(id: "1111", name: "name", platform: "steam"))
        })
    }
}

extension FavouriteViewModel: SceneViewModel {}
