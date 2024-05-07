//
//  MatchesViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 9/4/24.
//

import Foundation
import Combine

enum MatchesState {
    case idle
    case showMatches([MatchRepresentable]?)
    case showErrorMatches
}

final class MatchesViewModel: DataBindable {
    private var anySubscription: Set<AnyCancellable> = []
    private let dependencies: MatchesDependencies
    private let stateSubject = CurrentValueSubject<MatchesState, Never>(.idle)
    var state: AnyPublisher<MatchesState, Never>
    private let getMatchesSubject = PassthroughSubject<Void, Never>()
    @BindingOptional private var matchesId: [String]?
    @BindingOptional private var profile: IdAccountDataProfileRepresentable?
    
    init(dependencies: MatchesDependencies) {
        self.dependencies = dependencies
        state = stateSubject.eraseToAnyPublisher()
    }
    
    var dataBinding: DataBinding {
        dependencies.resolve()
    }
    
    func viewDidLoad() {
        subscribeMatchesPublisher()
        getMatchesSubject.send()
    }
    
    func backButton() {
        coordinator.goBack()
    }
}

private extension MatchesViewModel {
    var coordinator: MatchesCoordinator {
        return dependencies.resolve()
    }
    
    var matchesDataUseCase: MatchesDataUseCase {
        return dependencies.resolve()
    }
    
    func configureMatches(_ matches: [MatchDataProfileRepresentable]) {
        let matchesDefault = matches.map { DefaultMatch(map: $0.attributes.mapName,
                                                        gameMode: $0.attributes.gameMode,
                                                        kills: $0.included.first(where: {$0.attributes.stats?.name == profile?.name})?.attributes.stats?.kills ?? 0,
                                                        damage: $0.included.first(where: {$0.attributes.stats?.name == profile?.name})?.attributes.stats?.damageDealt ?? 0,
                                                        date: configureDate($0.attributes.createdAt),
                                                        position: $0.included.first(where: {$0.attributes.stats?.name == profile?.name})?.attributes.stats?.winPlace ?? 0) }
        self.stateSubject.send(.showMatches(matchesDefault))
    }
    
    func configureDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: dateString)
    }
}

//MARK: - Subscriptions
private extension MatchesViewModel {
    func subscribeMatchesPublisher() {
        matchesPublisher().sink { [weak self] completion in
            switch completion {
            case .failure(_):
                self?.stateSubject.send(.showErrorMatches)
                self?.subscribeMatchesPublisher()
            default: break
            }
        } receiveValue: { [weak self] matches in
            self?.configureMatches(matches)
        }.store(in: &anySubscription)
    }
}

//MARK: - Publishers
private extension MatchesViewModel {
    func matchesPublisher() -> AnyPublisher<[MatchDataProfileRepresentable], Error> {
        return getMatchesSubject.flatMap { [unowned self] _ in
            self.matchesDataUseCase.fetchMatches(matchesId ?? [], platform: profile?.platform ?? "")
        }.receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
