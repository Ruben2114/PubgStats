//
//  FavouriteViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 5/4/23.
//

import Foundation
import Combine

enum FavouriteState {
    case idle
    case showPlayerDetails([IdAccountDataProfileRepresentable])
    case showErrorPlayerDetails
    case showErrorSearchPlayer
    case hideLoading
}

final class FavouriteViewModel {
    private var anySubscription: Set<AnyCancellable> = []
    private let dependencies: FavouriteDependencies
    private let stateSubject = CurrentValueSubject<FavouriteState, Never>(.idle)
    var state: AnyPublisher<FavouriteState, Never>
    private let getFavouritesSubject = PassthroughSubject<Void, Never>()
    private let searchFavouriteSubject = PassthroughSubject<(String, String), Never>()
    var profilesFavourite: [IdAccountDataProfileRepresentable] = []
    
    init(dependencies: FavouriteDependencies) {
        self.dependencies = dependencies
        state = stateSubject.eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        subscribeGetFavouritePublisher()
        subscribeSearchFavouritePlayerPublisher()
        getFavouritesSubject.send()
    }
    
    func goToProfile(_ player: IdAccountDataProfileRepresentable?) {
        coordinator.goToProfile(data: player)
    }
    
    func deleteFavouriteTableView(_ profile: IdAccountDataProfileRepresentable){
        favouriteUseCase.deleteFavouritePlayer(profile)
    }
    
    func searchFavourite(name: String, platform: String){
        searchFavouriteSubject.send((name, platform))
    }
    
    func updateProfilesFavourite(_ name: String) {
        profilesFavourite.removeAll(where: {$0.name == name})
    }
}

private extension FavouriteViewModel {
    var coordinator: FavouriteCoordinator {
        return dependencies.resolve()
    }
    
    var favouriteUseCase: FavouriteDataUseCase {
        return dependencies.resolve()
    }
}

//MARK: - Subscriptions
private extension FavouriteViewModel {
    func subscribeGetFavouritePublisher() {
        getFavouritePlayerPublisher().sink { [weak self] completion in
            switch completion {
            case .failure(_):
                guard let self else { return }
                self.stateSubject.send(.showErrorPlayerDetails)
                self.stateSubject.send(.hideLoading)
                self.subscribeGetFavouritePublisher()
            default: break
            }
        } receiveValue: { [weak self] data in
            guard let self else { return }
            self.profilesFavourite = data
            self.stateSubject.send(.showPlayerDetails(data))
            self.stateSubject.send(.hideLoading)
        }.store(in: &anySubscription)
    }
    
    func subscribeSearchFavouritePlayerPublisher() {
        searchFavouritePlayerPublisher().sink { [weak self] completion in
            switch completion {
            case .failure(_):
                guard let self else { return }
                self.stateSubject.send(.showErrorSearchPlayer)
                self.stateSubject.send(.hideLoading)
                self.subscribeSearchFavouritePlayerPublisher()
            default: break
            }
        } receiveValue: { [weak self] data in
            guard let self else { return }
            self.profilesFavourite.append(data)
            self.stateSubject.send(.showPlayerDetails(profilesFavourite))
            self.stateSubject.send(.hideLoading)
        }.store(in: &anySubscription)
    }
}

//MARK: - Publishers
private extension FavouriteViewModel {
    func getFavouritePlayerPublisher() -> AnyPublisher<[IdAccountDataProfileRepresentable], Error> {
        return getFavouritesSubject.flatMap { [unowned self]  in
            favouriteUseCase.getFavouritesPlayers()
        }.receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func searchFavouritePlayerPublisher() -> AnyPublisher<IdAccountDataProfileRepresentable, Error> {
        return searchFavouriteSubject.flatMap { [unowned self] data in
            favouriteUseCase.fetchPlayerData(name: data.0, platform: data.1)
        }.receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}


