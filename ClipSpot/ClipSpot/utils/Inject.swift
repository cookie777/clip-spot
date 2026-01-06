//
//  Inject.swift
//  ClipSpot
//
//  Created by Takayuki Yamaguchi on 2026-01-03.
//
import SwiftUI

struct Inject<Content: View>: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.diContainer) private var diContainer: DIContainer
    let content: (AppState, DIContainer) -> Content
    
    init(@ViewBuilder content: @escaping (AppState, DIContainer) -> Content) {
        self.content = content
    }
    
    var body: some View {
        content(appState, diContainer)
    }
}

extension View {
    func inject<Content: View>(
        @ViewBuilder content: @escaping (AppState, DIContainer) -> Content
    ) -> some View {
        Inject(content: content)
    }
}
