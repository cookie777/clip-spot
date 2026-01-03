//
//  ClipSpotApp.swift
//  ClipSpot
//
//  Created by Takayuki Yamaguchi on 2026-01-01.
//

import SwiftUI

@main
struct ClipSpotApp: App {
    private let soundService: SoundService
    private let clipboardService: ClipboardService

    @StateObject private var appState: AppState
    @StateObject private var toastViewModel: ToastViewModel
    @StateObject private var menuBarViewModel: MenuBarViewModel

    init() {
        let soundService = SoundService()
        let clipboardService = ClipboardService()
        let appState = AppState()

        _appState = StateObject(wrappedValue: appState)
        _toastViewModel = StateObject(wrappedValue: ToastViewModel(
            soundService: soundService,
            clipboardService: clipboardService,
            settings: appState
        ))
        _menuBarViewModel = StateObject(wrappedValue: MenuBarViewModel(
            clipboardService: clipboardService,
            appState: appState
        ))

        self.soundService = soundService
        self.clipboardService = clipboardService
    }

    var body: some Scene {
        MenuBarExtra("CopyAlert", systemImage: "doc.on.doc") {
            MenuContentView(menuBarViewModel: menuBarViewModel)
        }

        // Settings window
        Settings {
            SettingsView(appState: appState)
        }
        .defaultSize(width: 800, height: 600)
    }
}
