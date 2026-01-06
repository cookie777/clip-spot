import SwiftUI
import AppKit
import Combine

@MainActor
final class ToastViewModel {

    var toastText: String = ""

    private let soundService: SoundService
    private let clipboardService: ClipboardService
    private let appState: AppState
    
    private var toastTask: Task<Void, Never>?
    private var toastWindow: NSWindow?

    init(
        appState: AppState,
        soundService: SoundService,
        clipboardService: ClipboardService,
    ) {
        self.soundService = soundService
        self.clipboardService = clipboardService
        self.appState = appState
    }

    func setupClipboardMonitoring() async {
        if !appState.monitoringEnabled { return }
        await clipboardService.startMonitoring()
        for await text in await clipboardService.copyPublisher {
            // Cancel previous toast
            let previousTask = toastTask
            previousTask?.cancel()
            await previousTask?.value

            // Start new toast on MainActor
            toastTask = Task { @MainActor in
                await displayToast(with: text)
            }
        }
    }


    private func displayToast(with text: String) async {
        createWindowIfNeeded()
        toastText = text

        await soundService.playNotificationSound(
            name: appState.soundName,
            volume: Double(appState.soundVolume)
        )
        await showWindow(text: text)
        if Task.isCancelled { // Cancel and return asap with resetting if requested
            cancelWindowAnimations(toastWindow)
            return
        }
        try? await Task.sleep(nanoseconds: UInt64(appState.toastDisplaySecond) * 1_000_000_000)
        if Task.isCancelled { // Sleep will immidiactly resume await and land here if cancel requested
            cancelWindowAnimations(toastWindow)
            return
        }
        await hideWindowIfVisible()
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

    private func showWindow(text: String) async {
        guard
            let window = toastWindow,
            let hosting = window.contentViewController as? NSHostingController<ToastView>
        else { return }

        hosting.rootView = ToastView(text: text, appState: appState)
        positionWindow(window: window)
        window.alphaValue = 0
        window.orderFront(nil)
        await animateWindowAlpha(window: window, to: 1, duration: 0.16)
    }
    

    private func hideWindowIfVisible() async {
        guard let window = toastWindow else { return }
        await animateWindowAlpha(window: window, to: 0, duration: 0.16)
        window.orderOut(nil)
    }

    
    private func animateWindowAlpha(
        window: NSWindow,
        to alpha: CGFloat,
        duration: TimeInterval
    ) async {
        await NSAnimationContext.runAnimationGroup { context in
            context.duration = duration
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            window.animator().alphaValue = alpha
        }
    }

    private func positionWindow(window: NSWindow) {
        guard let screen = NSScreen.main else { return }

        let frame = screen.visibleFrame
        let x = frame.maxX - appState.toastWidth - appState.toastMargin
        let y = frame.minY + appState.toastMargin

        window.setFrameOrigin(NSPoint(x: x, y: y))
    }
    
    private func cancelWindowAnimations(_ window: NSWindow?) {
        guard let window = window else { return }
        window.animator().alphaValue = 0
    }

    deinit {
        Task { @MainActor [weak self] in
            await self?.clipboardService.stopMonitoring()
        }
    }
}
