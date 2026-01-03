//
//  ClipSpotApp.swift
//  ClipSpot
//
//  Created by Takayuki Yamaguchi on 2026-01-01.
//

import SwiftUI

@main
struct ClipSpotApp: App {

    @StateObject private var appState: AppState = AppState()
    private let diContainer: DIContainer = DIContainer()


    var body: some Scene {
        MenuBarExtra("CopyAlert", systemImage: "doc.on.doc") {
            MenuContentView(appState: appState, diContainer: diContainer)
        }

        Settings {
            SettingsView()
                .environmentObject(appState)
                .environment(\.diContainer, DIContainer())
        }
        .defaultSize(width: 800, height: 600)
    }
}
