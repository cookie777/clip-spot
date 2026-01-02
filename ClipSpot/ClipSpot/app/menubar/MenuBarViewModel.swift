//
//  MenuBarState.swift
//  CopyAlert
//
//  Created by Takayuki Yamaguchi on 2025-12-30.
//

import Combine

@MainActor
final class MenuBarViewModel: ObservableObject {
    private let clipboardService: ClipboardService
    private let appState: AppState
    
    init(clipboardService: ClipboardService, appState: AppState) {
        self.clipboardService = clipboardService
        self.appState = appState
    }
    
    func flipMonitoring() {
        if appState.monitoringEnabled {
            clipboardService.stopMonitoring()
        } else {
            clipboardService.startMonitoring()
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
