//
//  AttributesHomeViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 11/4/23.
//

import Combine

final class AttributesHomeViewModel: DataBindable {
    private var anySubscription: Set<AnyCancellable> = []
    private let dependencies: AttributesHomeDependencies
    private let stateSubject = PassthroughSubject<(AttributesType, [AttributesViewRepresentable]), Never>()
    var state: AnyPublisher<(AttributesType, [AttributesViewRepresentable]), Never>
    @BindingOptional private var attributesHomeList: [AttributesViewRepresentable]?
    @BindingOptional private var type: AttributesType?
    
    init(dependencies: AttributesHomeDependencies) {
        self.dependencies = dependencies
        state = stateSubject.eraseToAnyPublisher()
    }
    
    var dataBinding: DataBinding {
        dependencies.resolve()
    }
    
    func viewDidLoad() {
        guard let attributes = attributesHomeList,
              let type = type else { return }
        stateSubject.send((type, attributes))
    }
   
    func goGameMode(representable: AttributesViewRepresentable){
        coordinator.goGameMode(representable)
    }
    
    func backButton() {
        coordinator.goBack()
    }
}

private extension AttributesHomeViewModel {
    var coordinator: AttributesHomeCoordinator {
        return dependencies.resolve()
    }
}

