//
//  NextScreenView.swift
//  SafeOTP
//
//  Created by Сергей Матвеенко on 21.10.24.
//

import SwiftUI

struct NextScreenView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    
    var body: some View {
        Text("Next screen")
        Button("Go to previous screen") {
            coordinator.popToRoot()
        }
    }
}

#Preview {
    NextScreenView()
}
