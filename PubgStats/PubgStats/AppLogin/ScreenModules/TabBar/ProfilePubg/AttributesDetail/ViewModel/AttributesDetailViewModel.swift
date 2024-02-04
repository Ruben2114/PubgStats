//
//  AttributesDetailViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

import Combine

final class AttributesDetailViewModel: DataBindable {
    private var anySubscription: Set<AnyCancellable> = []
    private let dependencies: AttributesDetailDependencies
    private let stateSubject = PassthroughSubject<AttributesViewRepresentable, Never>()
    var state: AnyPublisher<AttributesViewRepresentable, Never>
    @BindingOptional private var attributesDetailList: AttributesViewRepresentable?
    
    
    init(dependencies: AttributesDetailDependencies) {
        self.dependencies = dependencies
        state = stateSubject.eraseToAnyPublisher()
    }
    
    var dataBinding: DataBinding {
        dependencies.resolve()
    }
    
    func viewDidLoad() {
        guard var attributes = attributesDetailList else { return }
        attributes.isDetails = true
        stateSubject.send(attributes)
    }
    
    func backButton() {
        coordinator.goBack()
    }
}

private extension AttributesDetailViewModel {
    var coordinator: AttributesDetailCoordinator {
        return dependencies.resolve()
    }
}
