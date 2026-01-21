//
//  View.swift
//  ClipSpot
//
//  Created by Takayuki Yamaguchi on 2026-01-20.
//

import SwiftUI

extension View {
    /// Conditionally removes the view from the view hierarchy (no space reserved).
    /// - Parameter shouldRemove: A boolean value that determines whether the view is removed.
    @ViewBuilder
    func removeIf(_ shouldRemove: Bool) -> some View {
        if !shouldRemove {
            self
        }
    }
    
    /// Conditionally renders the view from the view hierarchy (no space reserved).
    /// - Parameter shouldRender: A boolean value that determines whether the view is rendered
    @ViewBuilder
    func renderIf(_ shouldRender: Bool) -> some View {
        if shouldRender {
            self
        }
    }
    
    /// Conditionally applies view transformations.
    /// - Parameters:
    ///   - condition: A Boolean value that determines whether the transform is applied.
    ///   - transform: A closure that modifies the view when the condition is true.
    /// - Returns: Either the transformed view or the original view.
    @ViewBuilder
    func applyIf<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
