//
//  MenuBarView.swift
//  CopyAlert
//
//  Created by Takayuki Yamaguchi on 2025-12-30.
//
import SwiftUI

struct MenuContentView: View {    
    @Environment(\.openSettings) private var openSettings
    @ObservedObject var appState: AppState
    @StateObject private var menuBarViewModel: MenuBarViewModel
    private var toastViewModel: ToastViewModel
    
    init(appState: AppState, diContainer: DIContainer) {
        let vm = MenuBarViewModel(
            clipboardService: diContainer.clipboardService,
            appState: appState
        )
        self._menuBarViewModel = StateObject(wrappedValue: vm)
        
        let toastViewModel = ToastViewModel(
            appState: appState,
            soundService: diContainer.soundService,
            clipboardService: diContainer.clipboardService
        )
        self.appState = appState
        self.toastViewModel = toastViewModel
        
        Task(priority: .background) {
            await toastViewModel.setupClipboardMonitoring()
        }
    }
    
    var body: some View {
            Button("Settings") {
                openSettings()
                NSApp.activate(ignoringOtherApps: true) // bring app to front
            }
            Button(menuBarViewModel.monitoringLabel) {
                Task(priority: .background) {
                    await menuBarViewModel.updateMonitoring()
                }
            }
            Divider()
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
    }
}

#Preview {
    VStack {
        MenuContentView(
            appState: AppState(),
            diContainer: DIContainer()
        )
    }
}

