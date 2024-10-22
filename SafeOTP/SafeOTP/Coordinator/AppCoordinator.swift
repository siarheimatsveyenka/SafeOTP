//
//  Coordinator.swift
//  SafeOTP
//
//  Created by Сергей Матвеенко on 21.10.24.
//

import SwiftUI

final class AppCoordinator: Coordinatable {
    @Published var navPath = NavigationPath()
    
    func push(_ page: Screen) {
        self.navPath.append(page)
    }
    
    func pop() {
        self.navPath.removeLast()
    }
    
    func popToRoot() {
        self.navPath.removeLast(self.navPath.count)
    }
    
    @ViewBuilder
    func build(page: Screen) -> some View {
        switch page {
        case .main:
            MainScreenView<MainScreenViewModel>(
                viewModel: MainScreenViewModel(
                    base32decoder: Base32Decoder(),
                    otpGeneratorService: OTPGeneratorService(),
                    timeCounterService: TimeCounterService()
                )
            )
        case .qrScanner:
            NextScreenView()
        }
    }
}
