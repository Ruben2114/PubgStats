//
//  ApiClientService.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 21/3/23.
//

import Foundation
import Combine

protocol ApiClientService {
    func dataPlayer<T: Decodable>(url: URL) -> AnyPublisher<T, Error>
}
