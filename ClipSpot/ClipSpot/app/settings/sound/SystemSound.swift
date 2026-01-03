//
//  SystemSound.swift
//  CopyAlert
//
//  Created by Takayuki Yamaguchi on 2025-12-30.
//


import AppKit

enum SystemSound {

    /// List all sound *names* available in system & user sound folders
    static func soundNames() -> [String] {
        let dirs: [URL] = [
            URL(fileURLWithPath: "/System/Library/Sounds"),
            URL(fileURLWithPath: "/Library/Sounds"),
            FileManager.default.homeDirectoryForCurrentUser
                .appendingPathComponent("Library/Sounds")
        ]

        var names: Set<String> = []

        for dir in dirs {
            guard let files = try? FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil) else {
                continue
            }

            for file in files {
                let name = file.deletingPathExtension().lastPathComponent
                names.insert(name)
            }
        }

        return Array(names).sorted()
    }

    static func play(name: String, volume: Double) {
        guard let sound = NSSound(named: name) else { return }
        sound.volume = Float(volume)
        sound.play()
    }
}
