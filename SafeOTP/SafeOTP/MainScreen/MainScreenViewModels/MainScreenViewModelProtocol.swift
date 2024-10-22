//
//  MainScreenViewModelProtocol.swift
//  SafeOTP
//
//  Created by Сергей Матвеенко on 21.10.24.
//

import Foundation

protocol MainScreenViewModelProtocol: ObservableObject {
    var counterValue: Double { get }
    var scallingCounterValueSize: Double { get }
    var displayDataDict: [String: [MainScreenDisplayModel]] { get }
    var filteredDisplayDataDict: [String: [MainScreenDisplayModel]] { get }
    var notFilteredDictKeys: [String] { get }
    var filteredDictKeys: [String] { get }
    var selectedKey: String? { get set }
    
    func readyForDisplay()
    func copyCodeInBuffer()
}
