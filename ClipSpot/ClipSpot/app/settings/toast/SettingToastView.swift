//
//  SettingToastView.swift
//  ClipSpot
//
//  Created by Takayuki Yamaguchi on 2026-01-02.
//

import SwiftUI
import Combine

struct SettingToastView : View {
    @Environment(\.appearsActive) var appearsActive
    @ObservedObject var appState: AppState
    @StateObject private var toastPreviewWindowViewModel: ToastPreviewWindowViewModel
    
    init(appState: AppState) {
        self.appState = appState
        self._toastPreviewWindowViewModel = StateObject(wrappedValue: ToastPreviewWindowViewModel(appState: appState))
    }
    
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
                ColorPicker("Text Color", selection: $appState.toastTextColor)
                    .controlSize(.small)
                ColorPicker("Background Color", selection: $appState.toastBgColor)
                    .controlSize(.small)
            }
            
            Section("Position") {
                Picker("Position", selection: $appState.toastPosition) {
                    ForEach(Position.allCases, id: \.self) { position in
                        Text(position.displayName).tag(position)
                    }
                }
                .pickerStyle(.automatic)
            }
            
            Section("Size") {
                VStack(alignment: .leading) {
                    Toggle("Dynamic Size", isOn: $appState.toastDynamicSize)
                        .toggleStyle(.switch)
                    Text("Dynamically resize toast based on text, within width and height limits.")
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("Width")
                    Text("\(appState.toastWidth, specifier: "%.0f")")
                    Slider(value: $appState.toastWidth, in: 100...500) {
                    } minimumValueLabel: {
                        Text("100")
                    } maximumValueLabel: {
                        Text("500")
                    }
                    .controlSize(.mini)
                }
                HStack {
                    Text("Height")
                    Text("\(appState.toastHeight, specifier: "%.0f")")
                    Slider(value: $appState.toastHeight, in: 50...240) {
                    } minimumValueLabel: {
                        Text("50")
                    } maximumValueLabel: {
                        Text("240")
                    }
                    .controlSize(.mini)
                }
                HStack {
                    Text("Margin")
                    Text("\(appState.toastMargin, specifier: "%.0f")")
                    Slider(value: $appState.toastMargin, in: 0...64) {
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("64")
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

        }
        .formStyle(.grouped)
        .onAppear {
            print("appera")
            toastPreviewWindowViewModel.showPreview()
        }
        .onDisappear {
            print("diss")
            toastPreviewWindowViewModel.hidePreview()
        }
        .onReceive(appState.objectWillChange) {_ in
            toastPreviewWindowViewModel.updatePreview()
        }
        .onChange(of: appearsActive) { _, newValue in
            if newValue {
                toastPreviewWindowViewModel.showPreview()
            } else {
                toastPreviewWindowViewModel.hidePreview()
            }
        }
    }
    
    private static let sampleText = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
}


#Preview {
    SettingToastView(appState: AppState())
}
