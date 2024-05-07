//
//  ApiClientService.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 21/3/23.
//

import Foundation

protocol ApiClientService {
    func dataPlayer<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void)
}
