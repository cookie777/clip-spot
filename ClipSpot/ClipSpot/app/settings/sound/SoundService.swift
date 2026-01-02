//
//  SoundService.swift
//  CopyAlert
//
//  Created by Takayuki Yamaguchi on 2025-12-29.
//

import AppKit

actor SoundService {

    private var currentSound: NSSound?

    func playNotificationSound(name: String, volume: Double) {
        // Stop previous sound if still playing
        currentSound?.stop()

        let sound = NSSound(named: NSSound.Name(name))
        sound?.volume = Float(volume)
        sound?.play()

        currentSound = sound
    }

    func stopNotificationSound() {
        currentSound?.stop()
        currentSound = nil
    }
}
