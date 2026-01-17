//
//  ToastPreviewManager.swift
//  ClipSpot
//
//  Created by Takayuki Yamaguchi on 2026-01-03.
//

import SwiftUI
import AppKit
import Combine

@MainActor
final class ToastPreviewWindowViewModel: ObservableObject {
    private var previewWindow: NSWindow?
    private let appState: AppState
    
    private static let previewText = "This is a preview of how your toast notification will appear. Adjust settings to see changes in real-time."
    
    init(appState: AppState) {
        self.appState = appState
    }
    
    func showPreview() {
        createWindowIfNeeded()
        updatePreview()
        guard let window = previewWindow else { return }
        window.alphaValue = 1
        window.orderFront(nil)
    }
    
    func hidePreview() {
        guard let window = previewWindow else { return }
        window.orderOut(nil)
    }
    
    func updatePreview() {
        guard let window = previewWindow,
              let hosting = window.contentViewController as? NSHostingController<ToastView>
        else { return }
        
        hosting.rootView = ToastView(text: Self.previewText, appState: appState)
        positionWindow(window: window)
    }
    
    private func createWindowIfNeeded() {
        guard previewWindow == nil else { return }
        let hosting = NSHostingController(
            rootView: ToastView(text: Self.previewText, appState: appState)
        )

        let window = NSWindow(contentViewController: hosting)
        window.styleMask = [.borderless]
        window.isOpaque = false
        window.backgroundColor = .clear
        window.level = .floating
        window.ignoresMouseEvents = true
        window.hasShadow = true
        window.alphaValue = 1

        previewWindow = window
    }
    
    private func positionWindow(window: NSWindow) {
        guard let screen = NSScreen.main else { return }

        let frame = screen.visibleFrame
        let margin = appState.toastMargin
        let width = appState.toastWidth
        let height = appState.toastHeight
        
        let position = appState.toastPosition.calculatePosition(
            frame: frame,
            width: width,
            height: height,
            margin: margin
        )

        window.setFrameOrigin(position)
    }
}
