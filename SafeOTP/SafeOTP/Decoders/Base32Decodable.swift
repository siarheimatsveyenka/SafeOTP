//
//  Base32Decodable.swift
//  SafeOTP
//
//  Created by Сергей Матвеенко on 21.10.24.
//

import Foundation
import Combine

protocol Base32Decodable {
    var anyBase32toDataIsReadyPublisher: AnyPublisher<[DataModel], Never> { get }
    var anyBase32toDataErrorPublisher: AnyPublisher<Error, Never> { get }
    
    func decodeToData(_ base32: [DataModel])
}
