//
//  SettingSoundView.swift
//  ClipSpot
//
//  Created by Takayuki Yamaguchi on 2026-01-02.
//
import SwiftUI

struct SettingSoundView: View {
    private let sounds = SystemSound.soundNames()
    @ObservedObject var appState: AppState
    
    var body: some View {
        Form {
            Section("Pop-up") {
                HStack {
                    Text("Volume")
                    Text("\(appState.soundVolume * 100, specifier: "%.0f")")
                    Slider(value: $appState.soundVolume, in: 0...1) {
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("100")
                    }
                    .controlSize(.mini)
                }
                HStack {
                    Text("Sound")
                    Spacer()
                    Picker("", selection: $appState.soundName) {
                        ForEach(sounds, id: \.self) { name in
                            Text(name).tag(name)
                        }
                    }
                    .labelsHidden()
                    .onChange(of: appState.soundName) { _, newValue in
                        SystemSound.play(name: newValue, volume: appState.soundVolume)
                    }
                    Button("▶︎ Play") {
                        SystemSound.play(name: appState.soundName, volume: appState.soundVolume)
                    }
                }
            }
        }
        .formStyle(.grouped)
    }
}

#Preview {
    SettingSoundView(appState: AppState())
}
