//
//  Base32Decoder.swift
//  SafeOTP
//
//  Created by Сергей Матвеенко on 21.10.24.
//

import Foundation
import Combine

final class Base32Decoder: Base32Decodable {
    
    // MARK: - Errors enum
    
    private enum Base32Error: Error {
        case invalidBase32String
    }
    
    // MARK: - Parameters
    
    private let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"
    
    // MARK: - Publishers
    
    private let base32toDataIsReadyPublisher = PassthroughSubject<[DataModel], Never>()
    var anyBase32toDataIsReadyPublisher: AnyPublisher<[DataModel], Never> {
        self.base32toDataIsReadyPublisher.eraseToAnyPublisher()
    }
    
    private let base32toDataErrorPublisher = PassthroughSubject<Error, Never>()
    var anyBase32toDataErrorPublisher: AnyPublisher<Error, Never> {
        self.base32toDataErrorPublisher.eraseToAnyPublisher()
    }
    
    // MARK: - Decode to data
    
    func decodeToData(_ datas: [DataModel]) {
        do {
            try self.decode(datas)
        }
        
        catch let error {
            switch error {
            case Base32Error.invalidBase32String:
                self.base32toDataErrorPublisher.send(error)
                print("Invalid base 32 value. Description: \(error.localizedDescription)")
            default:
                self.base32toDataErrorPublisher.send(error)
                print("Decoding error. Description: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Handlers

private extension Base32Decoder {
    func decode(_ datas: [DataModel]) throws {
        var initialMainScreenData = [DataModel]()
        
        for data in datas {
            guard let privateKeyString = data.privateKey else { return }
            let base32 = privateKeyString.uppercased()
            let padding = base32.hasSuffix("=") ? base32.suffix(2).count : 0
            let base32Chars = base32.replacingOccurrences(of: "=", with: "")
            var bits = 0
            var accumulator = 0
            var result = Data()
            
            for char in base32Chars {
                guard let index = self.alphabet.firstIndex(of: char) else {
                    throw Base32Error.invalidBase32String
                }
                
                let value = self.alphabet.distance(from: self.alphabet.startIndex, to: index)
                accumulator = (accumulator << 5) | value
                bits += 5
                
                if bits >= 8 {
                    bits -= 8
                    
                    let byte = (accumulator >> bits) & 0xFF
                    result.append(UInt8(byte))
                }
            }
            
            if padding > 0 {
                let byteCount = (base32Chars.count * 5 - padding * 8) / 8
                result = result.prefix(byteCount)
            }
            
            initialMainScreenData.append(
                DataModel(
                    authenticationStandart: data.authenticationStandart,
                    tokenName: data.tokenName,
                    tokenAccountName: data.tokenAccountName,
                    privateKeyData: result,
                    issuerName: data.issuerName,
                    algorithm: data.algorithm,
                    numberOfDigits: data.numberOfDigits,
                    period: data.period
                )
            )
        }
        self.base32toDataIsReadyPublisher.send(initialMainScreenData)
    }
}

