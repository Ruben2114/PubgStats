//
//  MatchesDependencies.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 9/4/24.
//

protocol MatchesDependencies {
    var external: MatchesExternalDependencies { get }
    func resolve() -> MatchesViewController
    func resolve() -> MatchesViewModel
    func resolve() -> MatchesDataUseCase
    func resolve() -> DataBinding
    func resolve() -> MatchesCoordinator
}

extension MatchesDependencies {
    func resolve() -> MatchesViewController {
        MatchesViewController(dependencies: self)
    }
    
    func resolve() -> MatchesViewModel {
        MatchesViewModel(dependencies: self)
    }
    
    func resolve() -> MatchesDataUseCase {
        MatchesDataUseCaseImp(dependencies: self)
    }
}
