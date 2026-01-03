//
//  MenuBarView.swift
//  CopyAlert
//
//  Created by Takayuki Yamaguchi on 2025-12-30.
//
import SwiftUI

struct MenuContentView: View {
    @Environment(\.openSettings) private var openSettings
    @ObservedObject var menuBarViewModel: MenuBarViewModel
    

    var body: some View {
        Button("Settings") {
            openSettings()
            NSApp.activate(ignoringOtherApps: true) // bring app to front
        }

        Divider()
        
        Button(menuBarViewModel.monitoringLabled) {
            Task {
                await menuBarViewModel.flipMonitoring()
            }
        }
        
        Divider()

        Button("Quit") {
            NSApplication.shared.terminate(nil)
        }
    }
}
