//
//  PersonalDataFactory.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 16/3/23.
//
import UIKit

protocol PersonalDataFactory {
    func makeModule(coordinator: PersonalDataViewControllerCoordinator) -> UIViewController
}

struct PersonalDataFactoryImp: PersonalDataFactory {
    private(set) var appContainer: AppContainer
    
    func makeModule(coordinator: PersonalDataViewControllerCoordinator) -> UIViewController {
        let personalDataViewController = PersonalDataViewController()
        return personalDataViewController
    }
}
