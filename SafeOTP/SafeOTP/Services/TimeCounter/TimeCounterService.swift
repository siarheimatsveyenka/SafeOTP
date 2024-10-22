//
//  TimeCounterService.swift
//  SafeOTP
//
//  Created by Сергей Матвеенко on 22.10.24.
//

import Foundation
import Combine

final class TimeCounterService: TimeCounterServiceProtocol {
    
    // MARK: - Parameters
    
    private let timeCounterValueUpdatedPublisher = PassthroughSubject<Double, Never>()
    var anyTimeCounterValueUpdatedPublisher: AnyPublisher<Double, Never> {
        self.timeCounterValueUpdatedPublisher.eraseToAnyPublisher()
    }
    
    private let recalculateKeysPublisher = PassthroughSubject<Void, Never>()
    var anyRecalculateKeysPublisher: AnyPublisher<Void, Never> {
        self.recalculateKeysPublisher.eraseToAnyPublisher()
    }
    
    private let scallingSizeUpdatedPublisher = PassthroughSubject<Double, Never>()
    var anyScallingSizeUpdatedPublisher: AnyPublisher<Double, Never> {
        self.scallingSizeUpdatedPublisher.eraseToAnyPublisher()
    }
    
    // MARK: - Calculating methods
    
    func calculateTimerCounterValue() {
        guard let currentSecondValue = Double(Date.now.formatted(.dateTime.second())) else { return }
        
        let timeCounterValue = currentSecondValue > 30
        ? currentSecondValue - 30
        : currentSecondValue
        
        self.calculateValueScallingSize(for: timeCounterValue)
        self.timeCounterValueUpdatedPublisher.send(timeCounterValue)

        switch timeCounterValue {
        case 0, 30:
            self.recalculateKeysPublisher.send()
        default:
            break
        }
    }
    
    private func calculateValueScallingSize(for value: Double) {
        switch value {
        case 29:
            self.scallingSizeUpdatedPublisher.send(1.05)
        default:
            self.scallingSizeUpdatedPublisher.send(1.0)
        }
    }
}
