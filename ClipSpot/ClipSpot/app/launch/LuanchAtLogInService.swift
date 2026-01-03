//
//  LaunchAtLogInService.swift
//  ClipSpot
//
//  Created by Takayuki Yamaguchi on 2026-01-02.
//

import Foundation
import ServiceManagement

actor LaunchAtLoginService {

    // Enable or disable launch at login
    func setEnabled(_ enabled: Bool) throws {
        if enabled {
            try SMAppService.mainApp.register()
        } else {
            try SMAppService.mainApp.unregister()
        }
    }
}

