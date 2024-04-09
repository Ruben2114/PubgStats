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
    case showMatches([MatchDataProfileRepresentable]?)
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
        if matchesId?.isEmpty == false {
            getMatchesSubject.send()
        } else {
            stateSubject.send(.showMatches([]))
        }
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
            self?.stateSubject.send(.showMatches(matches))
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
