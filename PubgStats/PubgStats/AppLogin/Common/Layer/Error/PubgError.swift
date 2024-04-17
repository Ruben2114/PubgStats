//
//  PubgError.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/3/23.
//

import Foundation

public enum PubgError: Error {
    case network
    case manyRequest
    case other
    //TODO: poner bien lo del internet el code
    //TODO: poner la skeys
    static func getError(_ error: Error) -> String? {
        guard let urlError = error as? URLError else { return nil }
        switch urlError.errorCode {
        case 429: return "Demasiadas llamadas poner key"
        case 1009: return "Problemas con el internet"
        default: return nil
        }
    }
}
