//
//  String+Hash.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 14/3/23.
//
import CommonCrypto
import Foundation

extension String {
    func hashString() -> String? {
        let inputData = Data(self.utf8)
        var outputData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        _ = outputData.withUnsafeMutableBytes { outputBytes in
            inputData.withUnsafeBytes { inputBytes in
                CC_SHA256(inputBytes.baseAddress, CC_LONG(inputData.count), outputBytes.baseAddress)
            }
        }
        return outputData.map { String(format: "%02hhx", $0) }.joined()
    }
}
