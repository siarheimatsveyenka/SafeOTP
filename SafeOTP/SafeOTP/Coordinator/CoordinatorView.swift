//
//  CoordinatorView.swift
//  SafeOTP
//
//  Created by Сергей Матвеенко on 21.10.24.
//

import SwiftUI

struct CoordinatorView<Coordinating: Coordinatable>: View {
    
    // MARK: - Parameters
    
    @StateObject private var coordinator: Coordinating
    
    // MARK: - Initialization
    
    init(coordinator: Coordinating) {
        self._coordinator = StateObject(wrappedValue: coordinator)
    }
    
    // MARK: - Body view
    
    var body: some View {
        NavigationStack(path: $coordinator.navPath) {
            coordinator.build(page: .main)
                .navigationDestination(for: Screen.self) { page in
                    coordinator.build(page: page)
                }
        }
        .environmentObject(coordinator)
    }
}

#Preview {
    CoordinatorView(coordinator: AppCoordinator())
}
