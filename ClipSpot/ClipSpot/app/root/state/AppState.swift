//
//  AppSettings.swift
//  CopyAlert
//
//  Created by Takayuki Yamaguchi on 2025-12-29.
//

import SwiftUI
import Combine

protocol IAppState: ObservableObject {
    var toastWidth: Double { get set }
    var toastHeight: Double { get set }
    var toastOpacity: Double { get set }
    var soundName: String { get set }
    var soundVolume: Double { get set }
    var toastMargin: Double { get set }
    var toastFontSize: Double { get set }
    var toastShowTitle: Bool { get set }
    var toastShowCopyContent: Bool { get set }
    var toastDisplaySecond: Double { get set }
    var launchAtLogin: Bool { get set }
    
    var monitoringEnabled: Bool { get set }

    var toastBgColor: Color { get set }
    var toastTextColor: Color { get set }
}

final class AppState: IAppState {
    @AppStorage("toastWidth") var toastWidth: Double = 400
    @AppStorage("toastHeight") var toastHeight: Double = 160
    @AppStorage("toastOpacity") var toastOpacity: Double = 0.9
    @AppStorage("soundName") var soundName: String = "Blow"
    @AppStorage("soundVolume") var soundVolume: Double = 0.5
    @AppStorage("toastBackgroundColorData") private var toastBackgroundColorData: Data?
    @AppStorage("toastTextColorData") private var toastTextColorData: Data?
    @AppStorage("toastMargin") var toastMargin: Double = 16
    @AppStorage("toastFontSize") var toastFontSize: Double = 14
    @AppStorage("toastShowTitle") var toastShowTitle: Bool = true
    @AppStorage("toastShowTitle") var toastShowCopyContent: Bool = true
    @AppStorage("toastDisplaySecond") var toastDisplaySecond: Double = 1.0
    @AppStorage("launchAtLogin") var launchAtLogin: Bool = true
    
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

class MockAppState: IAppState {
    var toastWidth: Double = 400
    var toastHeight: Double = 160
    var toastOpacity: Double = 0.9
    var soundName: String = "Blow"
    var soundVolume: Double = 0.5
    private var toastBackgroundColorData: Data?
    private var toastTextColorData: Data?
    var toastMargin: Double = 16
    var toastFontSize: Double = 14
    var toastShowTitle: Bool = true
    var toastShowCopyContent: Bool = true
    var toastDisplaySecond: Double = 1.0
    var launchAtLogin: Bool = true
    
    var monitoringEnabled: Bool = true

    var toastBgColor: Color {
        get {
            Color.fromData(toastBackgroundColorData ?? Data()) ?? Color.taostBackground
        }
        set {
            toastBackgroundColorData = newValue.toData()
        }
    }
    
    var toastTextColor: Color {
        get {
            Color.fromData(toastTextColorData ?? Data()) ?? Color.toastText
        }
        set {
            toastTextColorData = newValue.toData()
        }
    }
}
