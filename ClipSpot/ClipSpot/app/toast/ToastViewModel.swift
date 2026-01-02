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

        await showWindow(text: text)

        try? await Task.sleep(nanoseconds: UInt64(appState.toastDisplaySecond) * 1_000_000_000)

        await hideWindow()
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

    @MainActor
    private func showWindow(text: String) async {
        createWindowIfNeeded()

        guard
            let window = toastWindow,
            let hosting = window.contentViewController as? NSHostingController<ToastView>
        else { return }

        hosting.rootView = ToastView(text: text, appState: appState)
        positionWindow(window: window)

        window.makeKeyAndOrderFront(nil)

        await animateWindowAlpha(window: window, to: 1, duration: 0.16)
    }

    @MainActor
    private func hideWindow() async {
        guard let window = toastWindow else { return }
        await animateWindowAlpha(window: window, to: 0, duration: 0.24)
        window.orderOut(nil)
    }
    
    @MainActor
    private func animateWindowAlpha(window: NSWindow, to alpha: CGFloat, duration: TimeInterval) async {
        await withCheckedContinuation { continuation in
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = duration
                context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                window.animator().alphaValue = alpha
            }, completionHandler: {
                continuation.resume()
            })
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
