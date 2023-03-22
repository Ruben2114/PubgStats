//
//  StateController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/3/23.
//

import Foundation

enum StateController {
    case success
    case loading
    case fail(error: String)
}

enum Output {
    case fail(error: String)
    case success (model: URLRequest)
    case loading
}
enum OutputPlayer {
    case fail(error: String)
    case success (model: PubgPlayer)
    case loading
}

