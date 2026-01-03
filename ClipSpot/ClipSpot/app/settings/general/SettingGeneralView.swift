//
//  SettingGeneralView.swift
//  ClipSpot
//
//  Created by Takayuki Yamaguchi on 2026-01-02.
//

import SwiftUI

struct SettingGeneralView: View {
    @ObservedObject var appState: AppState
    @StateObject private var settingGeneralViewModel: SettingGeneralViewModel
    
    init(
        appState: AppState,
        launchAtLoginService: LaunchAtLoginService
    ) {
        self.appState = appState
        self._settingGeneralViewModel = StateObject(wrappedValue: SettingGeneralViewModel(launchAtLoginService: launchAtLoginService)
        )
    }
    
    var body: some View {
        Toggle("Launched At Login", isOn: $appState.launchAtLogin)
            .toggleStyle(.switch)
            .onChange(of: appState.launchAtLogin) { _, newValue in
                Task {
                    try? await settingGeneralViewModel.setLaunchAtLogin(newValue)
                }
            }
    }
}

#Preview {
    SettingGeneralView(appState: AppState(), launchAtLoginService: LaunchAtLoginService())
}
