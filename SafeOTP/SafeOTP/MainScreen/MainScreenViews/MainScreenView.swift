//
//  ContentView.swift
//  SafeOTP
//
//  Created by Сергей Матвеенко on 21.10.24.
//

import SwiftUI

struct MainScreenView<ViewModel: MainScreenViewModelProtocol>: View {
    
    // MARK: - Parameters
        
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var viewModel: ViewModel
    
    // MARK: - Initialization
    
    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: - Initialization
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            Button("Test view") {
                coordinator.push(.qrScanner)
            }
        }
        .padding()
    }
}

#Preview {
    MainScreenView<MainScreenViewModel>(
        viewModel: MainScreenViewModel(
            base32decoder: Base32Decoder(),
            otpGeneratorService: OTPGeneratorService()
        )
    )
}
