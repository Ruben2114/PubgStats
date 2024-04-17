//
//  MatchesDataUseCase.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 9/4/24.
//

import Foundation
import Combine

protocol MatchesDataUseCase {
    func fetchMatches(_ id: [String], platform: String) -> AnyPublisher<[MatchDataProfileRepresentable], Error>
}

struct MatchesDataUseCaseImp {
    private let profileRepository: DataPlayerRepository
    
    init(dependencies: MatchesDependencies) {
        self.profileRepository = dependencies.external.resolve()
    }
}

extension MatchesDataUseCaseImp: MatchesDataUseCase {
    func fetchMatches(_ id: [String], platform: String) -> AnyPublisher<[MatchDataProfileRepresentable], Error> {
        let publisher = id.map { profileRepository.fetchMatchesData(id: $0, platform: platform)}
        return Publishers.MergeMany(publisher).collect().eraseToAnyPublisher()
    }
}
