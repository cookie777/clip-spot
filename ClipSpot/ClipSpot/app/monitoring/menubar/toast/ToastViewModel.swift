//
//  ToastViewModel.swift
//  ClipSpot
//
//  Created by Takayuki Yamaguchi on 2026-01-16.
//


import Combine
import Foundation

@MainActor
final class ToastViewModel: ObservableObject {
    @Published var copyText: String = ""
    
    private let appState: AppState
    private let copyTextOriginal: String
    private var cancellables = Set<AnyCancellable>()
    
    init(appState: AppState, copyText: String) {
        self.appState = appState
        self.copyTextOriginal = copyText
        // Initialize with the original text
        self.copyText = copyText
        
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        $copyText
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] newValue in
                guard let self = self else { return }
                if !appState.toastShowCopyContent {
                    copyText = "Copy to Clipboard"
                    return
                }
                let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                // Only update if the trimmed version is actually different
                if newValue != trimmed {
                    copyText = trimmed
                }
            }
            .store(in: &cancellables)
    }
}







//
