//
//  color.swift
//  CopyAlert
//
//  Created by Takayuki Yamaguchi on 2025-12-30.
//

import SwiftUI

extension Color {
    func toData() -> Data? {
        let nsColor = NSColor(self)
        return try? NSKeyedArchiver.archivedData(
            withRootObject: nsColor,
            requiringSecureCoding: false
        )
    }

    static func fromData(_ data: Data) -> Color? {
        guard let nsColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: data) else {
            return nil
        }
        return Color(nsColor)
    }
}
