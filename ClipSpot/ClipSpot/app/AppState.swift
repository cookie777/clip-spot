//
//  AppSettings.swift
//  CopyAlert
//
//  Created by Takayuki Yamaguchi on 2025-12-29.
//

import SwiftUI
import Combine

final class AppState: ObservableObject {
    @AppStorage("toastWidth") var toastWidth: Double = 400
    @AppStorage("toastHeight") var toastHeight: Double = 160
    @AppStorage("toastOpacity") var toastOpacity: Double = 0.9
    @AppStorage("soundName") var soundName: String = "Blow"
    @AppStorage("soundVolume") var soundVolume: Double = 0.5
    @AppStorage("toastBackgroundColorData") private var toastBackgroundColorData: Data?
    @AppStorage("toastTextColorData") private var toastTextColorData: Data?
    @AppStorage("toastMarging") var toastMarging: Double = 16
    @AppStorage("toastFontSize") var toastFontSize: Double = 14
    @AppStorage("toastShowTitle") var toastShowTitle: Bool = true
    @AppStorage("toastShowTitle") var toastShowCopyContent: Bool = true
    @AppStorage("toastDisplaySecond") var toastDisplaySecond: Double = 1.0
    
    @Published var monitoringEnabled: Bool = true

    var toastBgColor: Color {
        get {
            Color.fromData(toastBackgroundColorData ?? Data()) ?? Color.taostBackground
        }
        set {
            toastBackgroundColorData = newValue.toData()
            objectWillChange.send()
        }
    }
    
    var toastTextColor: Color {
        get {
            Color.fromData(toastTextColorData ?? Data()) ?? Color.toastText
        }
        set {
            toastTextColorData = newValue.toData()
            objectWillChange.send()
        }
    }
}
