//
//  MainScreenViewModel.swift
//  SafeOTP
//
//  Created by Сергей Матвеенко on 21.10.24.
//

import SwiftUI
import Combine

final class MainScreenViewModel: MainScreenViewModelProtocol {
    
    // MARK: - Parameters
    
    private var cancellables: Set<AnyCancellable> = []
    private let base32decoder: Base32Decodable
    private let otpGeneratorService: OTPGeneratorServiceProtocol
    
    // MARK: - Initialization
    
    init(base32decoder: Base32Decodable, otpGeneratorService: OTPGeneratorServiceProtocol) {
        self.base32decoder = base32decoder
        self.otpGeneratorService = otpGeneratorService
    }
}
