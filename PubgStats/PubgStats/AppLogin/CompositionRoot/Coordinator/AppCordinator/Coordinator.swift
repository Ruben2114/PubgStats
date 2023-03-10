//
//  Coordinator.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/3/23.
//
import UIKit

protocol Coordinator {
    var navigation: UINavigationController { get }
    func start()
}
