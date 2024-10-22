//
//  View+Extension.swift
//  SafeOTP
//
//  Created by Сергей Матвеенко on 22.10.24.
//

import SwiftUI

extension View {
    func configureBackgroundGradientColor(for colorScheme: ColorScheme) -> LinearGradient {
        switch colorScheme {
        case .light:
            LinearGradient(colors: [.white, .blue.opacity(0.2)], startPoint: .bottom, endPoint: .top)
        case .dark:
            LinearGradient(colors: [.white, .green.opacity(0.2)], startPoint: .bottom, endPoint: .top)
        @unknown default:
            LinearGradient(colors: [.white, .yellow.opacity(0.2)], startPoint: .bottom, endPoint: .top)
        }
    }
}
