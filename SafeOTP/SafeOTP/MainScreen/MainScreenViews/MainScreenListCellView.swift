//
//  MainScreenListCellView.swift
//  SafeOTP
//
//  Created by Сергей Матвеенко on 22.10.24.
//

import SwiftUI

struct MainListCellView: View {
    
    // MARK: - Parameters
    
    private let accountDisplayData: MainScreenDisplayModel
    private var counterTimeValue: Double
    
    // MARK: - Initialization
    
    init(accountDisplayData: MainScreenDisplayModel, ringTime: Double) {
        self.accountDisplayData = accountDisplayData
        self.counterTimeValue = ringTime
    }
    
    // MARK: - Body view
    
    var body: some View {
        GroupBox(accountDisplayData.accountName) {
            HStack {
                Label(
                    title: { Text(accountDisplayData.key) },
                    icon: { accountDisplayData.logo }
                )
                .font(.title)
                .fontWidth(.expanded)
                .bold()
                
                Spacer()
                
                Gauge(value: counterTimeValue, in: 0...30, label: {
                    Text("\(Int(30 - counterTimeValue))")
                        .scaleEffect(0.8)
                        .fontWeight(.black)
                        .foregroundStyle(getTimerColor())
                })
                .gaugeStyle(.accessoryCircularCapacity)
                .tint(getTimerColor())
                .shadow(color: .clear, radius: 0)
            }
        }
        .dynamicTypeSize(.xSmall ... .xxxLarge)
        .frame(maxWidth: .infinity)
        .fontDesign(.monospaced)
        .tint(.black)
    }
}

// MARK: - Update color for timer

private extension MainListCellView {
    var timerColors: [TimerLeftPeriod: Color] {
        [.tooLong: .green, .long: .mint, .upperMedium: .yellow, .medium: .orange, .upperClose: .brown, .close: .red]
    }
    
    func getTimerColor() -> Color {
        switch (30 - counterTimeValue) {
        case 0...5:
            guard let color = timerColors[.close] else { return .pink }
            return color
        case 6...10:
            guard let color = timerColors[.upperClose] else { return .pink }
            return color
        case 11...15:
            guard let color = timerColors[.medium] else { return .pink }
            return color
        case 16...20:
            guard let color = timerColors[.upperMedium] else { return .pink }
            return color
        case 21...25:
            guard let color = timerColors[.long] else { return .pink }
            return color
        case 26...30:
            guard let color = timerColors[.tooLong] else { return .pink }
            return color
        default:
            return .red
        }
    }
}

