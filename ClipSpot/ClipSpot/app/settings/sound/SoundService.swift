//
//  SoundService.swift
//  CopyAlert
//
//  Created by Takayuki Yamaguchi on 2025-12-29.
//

import AppKit

final class SoundService {
    func playNotificationSound(name: String, volume: Double) {
        // macOS system sounds are located in /System/Library/Sounds
        let sound = NSSound(named: NSSound.Name(name))
        sound?.volume = Float(volume)
        sound?.play()
    }
}
