//
//  SettingGeneralViewModel.swift
//  ClipSpot
//
//  Created by Takayuki Yamaguchi on 2026-01-02.
//
import Combine

actor SettingGeneralViewModel: ObservableObject {
    private let launchAtLoginService: LaunchAtLoginService
    
    init(launchAtLoginService: LaunchAtLoginService) {
        self.launchAtLoginService = launchAtLoginService
    }
    
    @concurrent
    func setLaunchAtLogin(_ isEnabled: Bool) async throws {
        try? await launchAtLoginService.setEnabled(isEnabled)
    }
}
