//
//  DataModel.swift
//  SafeOTP
//
//  Created by Сергей Матвеенко on 21.10.24.
//

import Foundation

struct DataModel {
    var authenticationStandart: AuthStandart
    var tokenName: String
    var tokenAccountName: String
    var privateKey: String?
    var privateKeyData: Data?
    var issuerName: String
    var algorithm: SecureAlgorithm
    var numberOfDigits: Int
    var period: TimeInterval
}
