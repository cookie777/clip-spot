//
//  Logger.swift
//  ClipSpot
//
//  Created by Takayuki Yamaguchi on 2026-01-03.
//

import os
import Foundation


nonisolated let LOG_ENABLED: Bool = true

protocol ILogger {}

extension ILogger  {
    // Shared Logger instance
    nonisolated private var logger: Logger {
        Logger.shared
    }
    
    nonisolated
    func info(_ message: String) {
        if !LOG_ENABLED { return }
        logger.info("\(message, privacy: .private)")
    }
    
    nonisolated
    func debug(_ message: String) {
        if !LOG_ENABLED { return }
        logger.debug("\(message, privacy: .private)")
    }
    
    nonisolated
    func warn(_ message: String) {
        if !LOG_ENABLED { return }
        logger.log(level: .default, "\(message, privacy: .private)")
    }
    
    nonisolated
    func error(_ message: String) {
        if !LOG_ENABLED { return }
        logger.error("\(message, privacy: .private)")
    }
}

extension Logger {
    nonisolated static let shared = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.takayuki.ClipSpot",
                               category: String(describing: Self.self))
}
