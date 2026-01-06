//
//  MenuBarState.swift
//  CopyAlert
//
//  Created by Takayuki Yamaguchi on 2025-12-30.
//

import Combine

@MainActor
final class MenuBarViewModel: ObservableObject, ILogger {
    private let clipboardService: ClipboardService
    private let appState: AppState

    
    init (clipboardService: ClipboardService, appState: AppState) {
        self.clipboardService = clipboardService
        self.appState = appState
    }
    
    func updateMonitoring() async {
        if !appState.monitoringEnabled {
            await clipboardService.startMonitoring()
        } else {
            await clipboardService.stopMonitoring()
        }
        appState.monitoringEnabled.toggle()
    }
    
    var monitoringLabel: String {
        if appState.monitoringEnabled {
            return "ClipSpot is active. Click to turn it off"
        } else {
            return "ClipSpot is not active. Click to turn it on"
        }
    }
}
