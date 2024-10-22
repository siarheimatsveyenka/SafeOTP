//
//  TimeCounterServiceProtocol.swift
//  SafeOTP
//
//  Created by Сергей Матвеенко on 22.10.24.
//

import Foundation
import Combine

protocol TimeCounterServiceProtocol {
    var anyTimeCounterValueUpdatedPublisher: AnyPublisher<Double, Never> { get }
    var anyRecalculateKeysPublisher: AnyPublisher<Void, Never> { get }
    var anyScallingSizeUpdatedPublisher: AnyPublisher<Double, Never> { get }
    
    func calculateTimerCounterValue()
}
