//
//  DIContainer.swift
//  ClipSpot
//
//  Created by Takayuki Yamaguchi on 2026-01-03.
//
import SwiftUI

private struct DIContainerKey: EnvironmentKey {
    static let defaultValue: DIContainer = DIContainer() // default fallback
}

extension EnvironmentValues {
    var diContainer: DIContainer {
        get { self[DIContainerKey.self] }
        set { self[DIContainerKey.self] = newValue }
    }
}

final class DIContainer {
    lazy var soundService: SoundService = SoundService()
    lazy var clipboardService: ClipboardService = ClipboardService()
    lazy var launchAtLoginService: LaunchAtLoginService = LaunchAtLoginService()
}
