//
//  GuideViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 16/3/23.
//
import Combine
import Foundation

final class GuideViewModel {
    var state = PassthroughSubject<Output, Never>()
    private let dependencies: GuideDependency
    init(dependencies: GuideDependency) {
        self.dependencies = dependencies
    }
    func checkUrl() {
        state.send(.loading)
        guard let myURL = URL(string: UrlGuide.url) else {return}
        let myRequest = URLRequest(url: myURL)
        state.send(.success(model: myRequest))
    }
}
