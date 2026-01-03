//
//  ClipBoardServices.swift
//  CopyAlert
//
//  Created by Takayuki Yamaguchi on 2025-12-29.
//


import AppKit
import Combine

actor ClipboardService {
    private let pasteboard = NSPasteboard.general
    private var lastChangeCount = NSPasteboard.general.changeCount
    private var timer: Task<(), Never>?

    // AsyncStream for clipboard events
    private var continuation: AsyncStream<String>.Continuation?
    var copyPublisher: AsyncStream<String> {
        AsyncStream { continuation in
            self.continuation = continuation
        }
    }

    func startMonitoring() {
        guard timer == nil else { return }
        timer = Task(priority: .utility) { [weak self] in
            while !Task.isCancelled {
                guard let self else { return }
                await self.checkPasteboard()
                try? await Task.sleep(nanoseconds: 500_000_000) // 0.5s
            }
        }
    }

    func stopMonitoring() {
        timer?.cancel()
        timer = nil
    }

    private func checkPasteboard() async {
        let current = pasteboard.changeCount
        guard current != lastChangeCount else { return }
        lastChangeCount = current

        guard !isSecuredRecourse(),
              let text = pasteboard.string(forType: .string),
              !text.isEmpty else {
            continuation?.yield("")
            return
        }

        continuation?.yield(text)
    }

    func isSecuredRecourse() -> Bool {
        guard let bundleID = NSWorkspace.shared.frontmostApplication?.bundleIdentifier else {
            return false
        }

        let blockedApps: Set<String> = [
            "com.1password.1password",
            "com.bitwarden.desktop",
            "com.apple.systempreferences",
            "com.agilebits.onepassword7",
            "com.bitwarden.desktop",
            "com.lastpass.LastPass",
            "com.dashlane.mac",
            "com.keepersecurity.mac",
            "com.sinew.EnpassMac",
            "com.nordpass.NordPass",
        ]

        return blockedApps.contains(bundleID)
    }
}
