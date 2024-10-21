//
//  OTPGeneratorService.swift
//  SafeOTP
//
//  Created by Сергей Матвеенко on 21.10.24.
//

import CryptoKit
import Combine
import SwiftUI

final class OTPGeneratorService: OTPGeneratorServiceProtocol {
    
    // MARK: - Publishers
    
    private let secretKeyIsReadyPublisher = PassthroughSubject<[MainScreenDisplayModel], Never>()
    var anySecretKeyIsReadyPublisher: AnyPublisher<[MainScreenDisplayModel], Never> {
        self.secretKeyIsReadyPublisher.eraseToAnyPublisher()
    }
    
    // MARK: - Generate OTP key

    func generateOTPkey(for initialDataArray: [DataModel]) {
        self.handleGenerateOTPkey(initialDataArray: initialDataArray)
    }
}

// MARK: - Handlers

private extension OTPGeneratorService {
    func handleGenerateOTPkey(initialDataArray: [DataModel]) {
        var displayDataArray = [MainScreenDisplayModel]()
        
        for initialData in initialDataArray {
            guard (6...8).contains(initialData.numberOfDigits) else {
                fatalError("Digits must be between 6 and 8.")
            }
            let counter: UInt64 = UInt64(Date().timeIntervalSince1970 / initialData.period)
            let counterData = withUnsafeBytes(of: counter.bigEndian) { Data($0) }
            let hmac: Data
            
            guard let keyData = initialData.privateKeyData else { return }
            
            switch initialData.algorithm {
            case .sha1:
                let key = SymmetricKey(data: keyData)
                hmac = Data(HMAC<Insecure.SHA1>.authenticationCode(for: counterData, using: key))
            case .sha256:
                let key = SymmetricKey(data: keyData)
                hmac = Data(HMAC<SHA256>.authenticationCode(for: counterData, using: key))
            case .sha512:
                let key = SymmetricKey(data: keyData)
                hmac = Data(HMAC<SHA512>.authenticationCode(for: counterData, using: key))
            }

            let offset = Int(hmac[hmac.count - 1] & 0x0f)
            let truncatedHash = UInt32(hmac.subdata(in: offset..<offset + 4).withUnsafeBytes {
                $0.load(
                    as: UInt32.self
                ).bigEndian
            }) & 0x7fffffff
            
            let pinValue = truncatedHash % UInt32(pow(10, Float(initialData.numberOfDigits)))
            let outputKey = String(format: "%0*u", initialData.numberOfDigits, pinValue)
            
            displayDataArray.append(
                MainScreenDisplayModel(
                    accountName: initialData.tokenAccountName,
                    key: outputKey,
                    logo: Image(.googleLogo),
                    groupValue: initialData.tokenName
                )
            )
        }
        self.secretKeyIsReadyPublisher.send(displayDataArray)
    }
}
