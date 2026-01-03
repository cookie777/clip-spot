//
//  SettingToastView.swift
//  ClipSpot
//
//  Created by Takayuki Yamaguchi on 2026-01-02.
//

import SwiftUI

struct SettingToastView : View {
    
    @ObservedObject var appState: AppState
    
    var body: some View {
        Form {
            Section("Animation") {
                HStack {
                    Text("Display Duration")
                    Text("\(appState.toastDisplaySecond, specifier: "%.2f")")
                        .opacity(0.8)
                    
                    Slider(value: $appState.toastDisplaySecond, in: 0.0...10) {
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("10")
                    }
                    .controlSize(.mini)
                }
            }

            Section("Color") {
                HStack {
                    Text("Opacity")
                    Text("\(appState.toastOpacity * 100, specifier: "%.0f")")
                        .opacity(0.8)
                    Slider(value: $appState.toastOpacity, in: 0.0...1) {
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("100")
                    }
                    .controlSize(.mini)
                }
                ColorPicker("Text Color", selection: $appState.toastTextColor)
                    .controlSize(.small)
                ColorPicker("Background Color", selection: $appState.toastBgColor)
                    .controlSize(.small)
            }
            
            Section("Size") {
                HStack {
                    Text("Width")
                    Text("\(appState.toastWidth, specifier: "%.0f")")
                    Slider(value: $appState.toastWidth, in: 100...600) {
                    } minimumValueLabel: {
                        Text("100")
                    } maximumValueLabel: {
                        Text("600")
                    }
                    .controlSize(.mini)
                }
                HStack {
                    Text("Height")
                    Text("\(appState.toastHeight, specifier: "%.0f")")
                    Slider(value: $appState.toastHeight, in: 50...300) {
                    } minimumValueLabel: {
                        Text("50")
                    } maximumValueLabel: {
                        Text("300")
                    }
                    .controlSize(.mini)
                }
                HStack {
                    Text("Margin")
                    Text("\(appState.toastMargin, specifier: "%.0f")")
                    Slider(value: $appState.toastMargin, in: 0...300) {
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("300")
                    }
                    .controlSize(.mini)
                }
                HStack {
                    Text("Font Size")
                    Text("\(appState.toastFontSize, specifier: "%.0f")")
                    Slider(value: $appState.toastFontSize, in: 1...64) {
                    } minimumValueLabel: {
                        Text("1")
                    } maximumValueLabel: {
                        Text("64")
                    }
                    .controlSize(.mini)
                }
            }


            Section("Text") {
                Toggle("Show Title", isOn: $appState.toastShowTitle)
                    .toggleStyle(.switch)
                Toggle("Show Content", isOn: $appState.toastShowCopyContent)
                    .toggleStyle(.switch)
            }

            Section("Preview") {
                HStack {
                    Spacer(minLength: 0)
                    VStack {
                        Spacer(minLength: 20)
                        ToastView(text: SettingToastView.sampleText, appState: appState)
                            .padding(appState.toastMargin)
                    }
                }
                .background(
                    Rectangle()
                        .fill(Color.black)
                        .padding(.bottom, 1)
                        .padding(.trailing, 1)
                        .background(Color.blue)
                )
            }

        }
        .formStyle(.grouped)
    }
    
    private static let sampleText = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
}

//
//#Preview {
//    SettingToastView(appState: AppState())
//}
