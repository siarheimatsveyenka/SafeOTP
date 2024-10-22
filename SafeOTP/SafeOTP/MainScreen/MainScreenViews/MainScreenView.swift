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
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var viewModel: ViewModel
    
    // MARK: - Initialization
    
    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: - Initialization
    
    var body: some View {
        NavigationStack {
            ZStack {
                List(selection: $viewModel.selectedKey) {
                    ForEach(
                        viewModel.filteredDisplayDataDict.isEmpty
                        ? viewModel.notFilteredDictKeys
                        : viewModel.filteredDictKeys,
                        id: \.self
                    ) { groupKey in
                        if let dataArray = viewModel.filteredDisplayDataDict[groupKey]?.isEmpty == false
                            ? viewModel.filteredDisplayDataDict[groupKey]?.sorted(by: { $0.accountName < $1.accountName })
                            : viewModel.displayDataDict[groupKey]?.sorted(by: { $0.accountName < $1.accountName }) {
                            Section {
                                ForEach(dataArray) { data in
                                    MainListCellView(
                                        accountDisplayData: data,
                                        ringTime: viewModel.counterValue
                                    )
                                    .tag(data.key)
                                    .backgroundStyle(.ultraThinMaterial)
                                    .navigationBarTitle("Secure codes".uppercased(), displayMode: .inline)
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                                    .shadow(radius: 8, x: 5, y: 5)
                                    .scaleEffect(viewModel.scallingCounterValueSize)
                                }
                            } header: {
                                Text(groupKey)
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .background(self.configureBackgroundGradientColor(for: colorScheme))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    leftItemView
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    rightItemView
                }
            }
            .onAppear {
                self.viewModel.readyForDisplay()
            }
            .onChange(of: viewModel.selectedKey) { _ in
                viewModel.copyCodeInBuffer()
            }
        }
    }
}

// MARK: - Toolbar item views

private extension MainScreenView {
    var leftItemView: some View {
        Menu {
            Button {

            } label: {
                Label("Scan QR code", systemImage: "qrcode.viewfinder")
            }
            .buttonStyle(.borderedProminent)
            .foregroundStyle(.black)
            .tint(.white)
            .fontWeight(.bold)
            .shadow(radius: 6, x: 2, y: 2)

            Divider()

            Button {

            } label: {
                Label("Manual input", systemImage: "keyboard.fill")
            }
            .buttonStyle(.borderedProminent)
            .foregroundStyle(.black)
            .tint(.white)
            .fontWeight(.bold)
            .shadow(radius: 6, x: 2, y: 2)
        } label: {
            Image(systemName: "slider.horizontal.3")
                .foregroundStyle(.black)
                .fontWeight(.black)
                .shadow(radius: 5)
        }
    }
    
    var rightItemView: some View {
        Menu {
            Button {

            } label: {
                Label("Scan QR code", systemImage: "qrcode.viewfinder")
            }
            .buttonStyle(.borderedProminent)
            .foregroundStyle(.black)
            .tint(.white)
            .fontWeight(.bold)
            .shadow(radius: 6, x: 2, y: 2)

            Divider()

            Button {

            } label: {
                Label("Manual input", systemImage: "keyboard.fill")
            }
            .buttonStyle(.borderedProminent)
            .foregroundStyle(.black)
            .tint(.white)
            .fontWeight(.bold)
            .shadow(radius: 6, x: 2, y: 2)
        } label: {
            Image(systemName: "plus.circle.fill")
                .foregroundStyle(.green, .black)
                .font(.title3)
                .fontWeight(.black)
                .shadow(radius: 5)
        }
    }
}

#Preview {
    MainScreenView<MainScreenViewModel>(
        viewModel: MainScreenViewModel(
            base32decoder: Base32Decoder(),
            otpGeneratorService: OTPGeneratorService(),
            timeCounterService: TimeCounterService()
        )
    )
}
