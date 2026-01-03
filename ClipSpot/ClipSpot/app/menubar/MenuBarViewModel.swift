//
//  MenuBarState.swift
//  CopyAlert
//
//  Created by Takayuki Yamaguchi on 2025-12-30.
//

import Combine

final class MenuBarViewModel: ObservableObject {
    private let clipboardService: ClipboardService
    private let appState: AppState
    
    init(clipboardService: ClipboardService, appState: AppState) {
        self.clipboardService = clipboardService
        self.appState = appState
    }
    
    func flipMonitoring() async {
        if appState.monitoringEnabled {
            await clipboardService.stopMonitoring()
        } else {
            await clipboardService.startMonitoring()
        }

        appState.monitoringEnabled.toggle()
        objectWillChange.send()
    }
    
    var monitoringLabled: String {
        if appState.monitoringEnabled {
            return "Disable Copy Alert (Currently ✅Enabled)"
        } else {
            return "Enable Copy Alert (Currently 😴Disabled)"
        }
    }
}
