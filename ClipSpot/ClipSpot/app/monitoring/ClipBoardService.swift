//
//  ClipBoardServices.swift
//  CopyAlert
//
//  Created by Takayuki Yamaguchi on 2025-12-29.
//


import AppKit
import Combine


final class ClipboardService {

    private let pasteboard = NSPasteboard.general
    private var lastChangeCount = NSPasteboard.general.changeCount
    private var timer: Task<(), Never>?

    var onCopyDetected: ((String) -> Void)?

    func startMonitoring() {
        if timer != nil { return }
        timer = Task(priority: .utility) { [weak self] in
            while !Task.isCancelled {
                  guard let self else { return }
                await self.checkPasteboard()
                try? await Task.sleep(nanoseconds: UInt64(0.5 * 1_000_000_000))
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
        if !isSecuredRecourse(), let text = pasteboard.string(forType: .string), !text.isEmpty {
            onCopyDetected?(text)
        } else {
            onCopyDetected?("")
        }
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

//
//final class ClipboardService {
//
//    private let pasteboard = NSPasteboard.general
//    private var lastChangeCount = NSPasteboard.general.changeCount
//    private var timer: Timer?
//
//    var onCopyDetected: ((String) -> Void)?
//
//    func startMonitoring() {
//        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
////            print(Thread.current)
//            Task {
//                await self.checkPasteboard()
//            }
//        }
//        timer?.tolerance = 0.3
//    }
//
//    func stopMonitoring() {
//        timer?.invalidate()
//        timer = nil
//    }
//
//    private func checkPasteboard() async {
//        let current = pasteboard.changeCount
//        guard current != lastChangeCount else { return }
//        lastChangeCount = current
//
//        if let text = pasteboard.string(forType: .string), !text.isEmpty {
//            onCopyDetected?(text)
//        }
//    }
//}
