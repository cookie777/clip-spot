import SwiftUI
import AppKit
import Combine

final class ToastViewModel: ObservableObject {

    @Published var toastText: String = ""
    @Published var showToast: Bool = false

    private let soundService: SoundService
    private let clipboardService: ClipboardService
    private let appState: AppState

    private var toastWindow: NSWindow?

    init(
        soundService: SoundService,
        clipboardService: ClipboardService,
        settings: AppState
    ) {
        self.soundService = soundService
        self.clipboardService = clipboardService
        self.appState = settings
        setupClipboardMonitoring()
    }

    private func setupClipboardMonitoring() {
        clipboardService.onCopyDetected = { [weak self] text in
            Task { await self?.displayToast(with: text) }
        }
        clipboardService.startMonitoring()
    }

    @MainActor
    private func displayToast(with text: String) async {
        toastText = text
        showToast = true

        soundService.playNotificationSound(
            name: appState.soundName,
            volume: Double(appState.soundVolume)
        )

        showWindow(text: text)

        try? await Task.sleep(nanoseconds: 1_000_000_000)

        hideWindow()
        showToast = false
    }

    private func createWindowIfNeeded() {
        guard toastWindow == nil else { return }

        let hosting = NSHostingController(
            rootView: ToastView(text: "", appState: appState)
        )

        let window = NSWindow(contentViewController: hosting)
        window.styleMask = [.borderless]
        window.isOpaque = false
        window.backgroundColor = .clear
        window.level = .floating
        window.ignoresMouseEvents = true
        window.hasShadow = true
        window.alphaValue = 0

        toastWindow = window
    }

    private func showWindow(text: String) {
        createWindowIfNeeded()

        guard
            let window = toastWindow,
            let hosting = window.contentViewController as? NSHostingController<ToastView>
        else { return }

        hosting.rootView = ToastView(text: text, appState: appState)
        positionWindow(window: window)

        window.makeKeyAndOrderFront(nil)

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.16
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            window.animator().alphaValue = 1
        }
    }

    private func hideWindow() {
        guard let window = toastWindow else { return }

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.24
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            window.animator().alphaValue = 0
        } completionHandler: {
            Task { @MainActor in
                window.orderOut(nil)
            }
        }
    }

    private func positionWindow(window: NSWindow) {
        guard let screen = NSScreen.main else { return }

        let frame = screen.visibleFrame
        let x = frame.maxX - appState.toastWidth - appState.toastMarging
        let y = frame.minY + appState.toastMarging

        window.setFrameOrigin(NSPoint(x: x, y: y))
    }

    deinit {
        Task { @MainActor [weak self] in
            self?.clipboardService.stopMonitoring()
        }
    }
}
