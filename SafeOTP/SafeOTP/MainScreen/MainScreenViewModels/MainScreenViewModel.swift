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
    private let timeCounterService: TimeCounterServiceProtocol
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Published var counterValue = Double()
    @Published var scallingCounterValueSize = Double()
    @Published var displayDataDict = [String: [MainScreenDisplayModel]]()
    @Published var filteredDisplayDataDict = [String: [MainScreenDisplayModel]]()
    @Published var notFilteredDictKeys = [String]()
    @Published var filteredDictKeys = [String]()
    @Published var selectedKey: String?
    
    private var secretDatas: [DataModel] = [
        DataModel(
            authenticationStandart: .totp,
            tokenName: "Google",
            tokenAccountName: "OKX",
            privateKey: "33SNVEIPRRZXHJZT",
            issuerName: "Google",
            algorithm: .sha1,
            numberOfDigits: 6,
            period: TimeInterval(30)
        ),
        DataModel(
            authenticationStandart: .totp,
            tokenName: "Apple",
            tokenAccountName: "1.bossmans@gmail.com",
            privateKey: "j5brszydeaqsmeck",
            issuerName: "Google",
            algorithm: .sha1,
            numberOfDigits: 6,
            period: TimeInterval(30)
        ),
        DataModel(
            authenticationStandart: .totp,
            tokenName: "Google",
            tokenAccountName: "2.bossmans@gmail.com",
            privateKey: "j5brszydeaqsmeck",
            issuerName: "Google",
            algorithm: .sha1,
            numberOfDigits: 6,
            period: TimeInterval(30)
        )
    ]
    
    // MARK: - Initialization
    
    init(
        base32decoder: Base32Decodable,
        otpGeneratorService: OTPGeneratorServiceProtocol,
        timeCounterService: TimeCounterServiceProtocol
    ) {
        self.base32decoder = base32decoder
        self.otpGeneratorService = otpGeneratorService
        self.timeCounterService = timeCounterService
    }
    
    // MARK: - Events
    
    func readyForDisplay() {
        self.bindTimer()
        self.decodeAndGetKeyForBase32String(self.secretDatas)
    }
    
    func copyCodeInBuffer() {
        guard let selectedKey else { return }
        UIPasteboard.general.string = selectedKey
    }
}

// MARK: - Timer binding

private extension MainScreenViewModel {
    func bindTimer() {
        self.timer
            .sink { _ in
                self.handleReceivedTimerData()
            }
            .store(in: &self.cancellables)
    }
    
    func handleReceivedTimerData() {
        self.timeCounterService.anyTimeCounterValueUpdatedPublisher
            .sink { [weak self] updatedCounterValue in
                guard let self else { return }
                self.counterValue = updatedCounterValue
            }
            .store(in: &self.cancellables)
        
        self.timeCounterService.anyScallingSizeUpdatedPublisher
            .sink { [weak self] updatedScallingSize in
                guard let self else { return }
                self.scallingCounterValueSize = updatedScallingSize
            }
            .store(in: &self.cancellables)
        
        self.timeCounterService.anyRecalculateKeysPublisher
            .sink { [weak self] in
                guard let self else { return }
                self.decodeAndGetKeyForBase32String(self.secretDatas)
            }
            .store(in: &self.cancellables)
        
        self.timeCounterService.calculateTimerCounterValue()
    }
}

// MARK: - Decoding and key generating

private extension MainScreenViewModel {
    func decodeAndGetKeyForBase32String(_ datas: [DataModel]) {
        self.cancellables.removeAll()
        
        self.base32decoder.anyBase32toDataIsReadyPublisher
            .sink { [weak self] decodedInitialData in
                guard let self else { return }
                self.generateOTP(for: decodedInitialData)
            }
            .store(in: &self.cancellables)
        
        self.base32decoder.decodeToData(datas)
    }
    
    func generateOTP(for secretDataArray: [DataModel]) {
        self.otpGeneratorService.anySecretKeyIsReadyPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] outputDisplayData in
                guard let self else { return }
                self.handleReceivedKeys(outputDisplayData)
            }
            .store(in: &self.cancellables)
        
        self.otpGeneratorService.generateOTPkey(for: secretDataArray)
    }
    
    func handleReceivedKeys(_ outputData: [MainScreenDisplayModel]) {
        if self.filteredDisplayDataDict.isEmpty {
            self.displayDataDict = Dictionary(grouping: outputData) {
                $0.groupValue ?? "Ungroupped"
            }
            
            self.notFilteredDictKeys = self.displayDataDict.keys.sorted(by: {$0 < $1})
        } else {
            self.filteredDisplayDataDict = Dictionary(grouping: outputData) {
                $0.groupValue ?? "Ungroupped"
            }
            
            self.filteredDictKeys = self.filteredDisplayDataDict.keys.sorted(by: {$0 < $1})
        }
        self.bindTimer()
    }
}
