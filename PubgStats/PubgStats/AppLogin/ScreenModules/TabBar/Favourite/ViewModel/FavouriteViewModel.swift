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
    case showError(String, [IdAccountDataProfileRepresentable])
    case deletePlayer(IdAccountDataProfileRepresentable?)
}

final class FavouriteViewModel {
    private var anySubscription: Set<AnyCancellable> = []
    private let dependencies: FavouriteDependencies
    private let stateSubject = CurrentValueSubject<FavouriteState, Never>(.idle)
    var state: AnyPublisher<FavouriteState, Never>
    private let getFavouritesSubject = PassthroughSubject<Void, Never>()
    private let deleteFavouritesSubject = PassthroughSubject<IdAccountDataProfileRepresentable, Never>()
    private let searchFavouriteSubject = PassthroughSubject<(String, String), Never>()
    var profilesFavourite: [IdAccountDataProfileRepresentable] = []
    private var deleteProfile: IdAccountDataProfileRepresentable?
    
    init(dependencies: FavouriteDependencies) {
        self.dependencies = dependencies
        state = stateSubject.eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        subscribeGetFavouritePublisher()
        subscribeSearchFavouritePlayerPublisher()
        subscribeDeleteFavouritePlayerPublisher()
        getFavouritesSubject.send()
    }
    
    func goToProfile(_ player: IdAccountDataProfileRepresentable?) {
        coordinator.goToProfile(data: player)
    }
    
    func deleteFavourite(_ profile: IdAccountDataProfileRepresentable) {
        deleteProfile = profile
        deleteFavouritesSubject.send(profile)
    }
    
    func searchFavourite(name: String, platform: String){
        searchFavouriteSubject.send((name, platform))
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
                //TODO: keys
                self.stateSubject.send(.showError("error al cargar los datos", profilesFavourite))
                self.subscribeGetFavouritePublisher()
            default: break
            }
        } receiveValue: { [weak self] data in
            guard let self else { return }
            self.profilesFavourite = data
            self.stateSubject.send(.showPlayerDetails(data))
        }.store(in: &anySubscription)
    }
    
    func subscribeSearchFavouritePlayerPublisher() {
        searchFavouritePlayerPublisher().sink { [weak self] completion in
            switch completion {
            case .failure(_):
                guard let self else { return }
                //TODO: keys
                self.stateSubject.send(.showError("no existe un usuario con este nombre", profilesFavourite))
                self.subscribeSearchFavouritePlayerPublisher()
            default: break
            }
        } receiveValue: { [weak self] data in
            guard let self else { return }
            self.profilesFavourite.append(data)
            self.stateSubject.send(.showPlayerDetails(profilesFavourite))
        }.store(in: &anySubscription)
    }
    
    func subscribeDeleteFavouritePlayerPublisher() {
        deleteFavouritePlayerPublisher().sink { [weak self] completion in
            switch completion {
            case .failure(_):
                guard let self else { return }
                //TODO: keys
                self.stateSubject.send(.showError("no se ha podido borrar", profilesFavourite))
                self.subscribeDeleteFavouritePlayerPublisher()
            default: break
            }
        } receiveValue: { [weak self] _ in
            guard let self else { return }
            self.profilesFavourite.removeAll(where: {$0.name == self.deleteProfile?.name})
            self.stateSubject.send(.deletePlayer(self.deleteProfile))
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
    
    func deleteFavouritePlayerPublisher() -> AnyPublisher<Void, Error> {
        return deleteFavouritesSubject.flatMap { [unowned self] data in
            favouriteUseCase.deleteFavouritePlayer(data)
        }.receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}


