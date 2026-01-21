//
//  ToastPosition.swift
//  ClipSpot
//
//  Created by Takayuki Yamaguchi on 2026-01-16.
//
import AppKit

enum Position: String, CaseIterable, Codable {
    case topLeft = "topLeft"
    case topCenter = "topCenter"
    case topRight = "topRight"
    case centerLeft = "centerLeft"
    case center = "center"
    case centerRight = "centerRight"
    case bottomLeft = "bottomLeft"
    case bottomCenter = "bottomCenter"
    case bottomRight = "bottomRight"
    
    var displayName: String {
        switch self {
        case .topLeft: return "Top Left"
        case .topCenter: return "Top Center"
        case .topRight: return "Top Right"
        case .centerLeft: return "Center Left"
        case .center: return "Center"
        case .centerRight: return "Center Right"
        case .bottomLeft: return "Bottom Left"
        case .bottomCenter: return "Bottom Center"
        case .bottomRight: return "Bottom Right"
        }
    }
    
    func calculatePosition(
        frame: NSRect,
        width: CGFloat,
        height: CGFloat,
        margin: CGFloat
    ) -> NSPoint {
        let x: CGFloat
        let y: CGFloat
        
        switch self {
        case .topLeft:
            x = frame.minX + margin
            y = frame.maxY - height - margin
        case .topCenter:
            x = frame.midX - width / 2
            y = frame.maxY - height - margin
        case .topRight:
            x = frame.maxX - width - margin
            y = frame.maxY - height - margin
        case .centerLeft:
            x = frame.minX + margin
            y = frame.midY - height / 2
        case .center:
            x = frame.midX - width / 2
            y = frame.midY - height / 2
        case .centerRight:
            x = frame.maxX - width - margin
            y = frame.midY - height / 2
        case .bottomLeft:
            x = frame.minX + margin
            y = frame.minY + margin
        case .bottomCenter:
            x = frame.midX - width / 2
            y = frame.minY + margin
        case .bottomRight:
            x = frame.maxX - width - margin
            y = frame.minY + margin
        }
        
        return NSPoint(x: x, y: y)
    }
    
    var isLeft: Bool {
        return self == .topLeft || self == .centerLeft || self == .bottomLeft
    }
    
    var isRight: Bool {
        return self == .topRight || self == .centerRight || self == .bottomRight
    }
    
    var isTop: Bool {
        return self == .topLeft || self == .topCenter || self == .topRight
    }
    
    var isBottom: Bool {
        return self == .bottomRight || self == .bottomCenter || self == .bottomLeft
    }
}
