//
//  AppSettings.swift
//  CopyAlert
//
//  Created by Takayuki Yamaguchi on 2025-12-29.
//

import SwiftUI
import Combine

@MainActor
final class AppState: ObservableObject {
    @AppStorage("toastWidth") var toastWidth: Double = 200
    @AppStorage("toastHeight") var toastHeight: Double = 400
    @AppStorage("toastOpacity") var toastOpacity: Double = 0.9
    @AppStorage("soundName") var soundName: String = "Pop"
    @AppStorage("soundVolume") var soundVolume: Double = 0.5
    @AppStorage("toastBackgroundColorData") private var toastBackgroundColorData: Data?
    @AppStorage("toastTextColorData") private var toastTextColorData: Data?
    @AppStorage("toastMarging") var toastMarging: Double = 12
    @AppStorage("toastFontSize") var toastFontSize: Double = 14
    @AppStorage("toastShowTitle") var toastShowTitle: Bool = true
    @AppStorage("toastShowTitle") var toastShowCopyContent: Bool = true
    
    @Published var monitoringEnabled: Bool = true

    var toastBgColor: Color {
        get {
            Color.fromData(toastBackgroundColorData ?? Data()) ?? .black
        }
        set {
            toastBackgroundColorData = newValue.toData()
            objectWillChange.send()
        }
    }
    
    var toastTextColor: Color {
        get {
            Color.fromData(toastTextColorData ?? Data()) ?? .white
        }
        set {
            toastTextColorData = newValue.toData()
            objectWillChange.send()
        }
    }
}
