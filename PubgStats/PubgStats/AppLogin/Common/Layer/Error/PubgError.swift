//
//  PubgError.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/3/23.
//

import Foundation

enum PubgError: Error {
    case network
    case manyRequest
    case other
    //TODO: poner bien lo del internet el code
    static func getError(_ error: Error) -> PubgError {
        guard let urlError = error as? URLError else { return .other }
        switch urlError.errorCode {
        case 429: return .manyRequest
        case 1009: return .network
        default: return .other
        }
    }
}


