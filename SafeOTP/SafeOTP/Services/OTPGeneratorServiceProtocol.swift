//
//  OTPGeneratorServiceProtocol.swift
//  SafeOTP
//
//  Created by Сергей Матвеенко on 21.10.24.
//

import Foundation

import Combine

protocol OTPGeneratorServiceProtocol {
    var anySecretKeyIsReadyPublisher: AnyPublisher<[MainScreenDisplayModel], Never> { get }
    
    func generateOTPkey(for initialDataArray: [DataModel])
}
