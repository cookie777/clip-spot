import SwiftUI

struct SettingsView: View {
    @ObservedObject var appState: AppState

    enum Section: String, CaseIterable, Identifiable {
//        case general = "General"
//        case shortcuts = "Shortcuts"
        case toast = "Toast"
        case sounds = "Sound"
        
        var id: String { rawValue }
    }

    @State private var selectedSection: Section? = .toast
    private let sounds = SystemSound.soundNames()

    var body: some View {
        NavigationSplitView {
            List(Section.allCases, id: \.self, selection: $selectedSection) { section in
                Label(section.rawValue, systemImage: iconName(for: section))
            }
            .listStyle(.sidebar)
            .frame(minWidth: 150)

        } detail: {
            switch selectedSection {
//            case .shortcuts:
//                Text("Shortcut settings here")
//                    .padding()
            case .toast:
                toastSettings
                    .padding()
            case .sounds:
                soundSettings
                    .padding()
            case .none:
                Text("Select a section")
                    .padding()
            }
        }
        .navigationTitle(selectedSection?.rawValue ?? "")
        .toolbar(.hidden)
    }

    private var toastSettings: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Display Duration")
                    Text("\(appState.toastDisplaySecond, specifier: "%.2f")")
                        .opacity(0.8)
                    Divider()
                    Slider(value: $appState.toastDisplaySecond, in: 0.0...10) {
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("10")
                    }
                    .controlSize(.mini)
                }
                HStack {
                    Text("Opacity")
                    Text("\(appState.toastOpacity * 100, specifier: "%.0f")")
                        .opacity(0.8)
                    Divider()
                    Slider(value: $appState.toastOpacity, in: 0.0...1) {
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("100")
                    }
                    .controlSize(.mini)
                }
                HStack {
                    Text("Width")
                    Text("\(appState.toastWidth, specifier: "%.0f")")
                    Divider()
                    Slider(value: $appState.toastWidth, in: 100...600) {
                    } minimumValueLabel: {
                        Text("100")
                    } maximumValueLabel: {
                        Text("600")
                    }
                    .controlSize(.mini)
                }
                HStack {
                    Text("Hieght")
                    Text("\(appState.toastHeight, specifier: "%.0f")")
                    Divider()
                    Slider(value: $appState.toastHeight, in: 50...300) {
                    } minimumValueLabel: {
                        Text("50")
                    } maximumValueLabel: {
                        Text("300")
                    }
                    .controlSize(.mini)
                }
                HStack {
                    Text("Marging")
                    Text("\(appState.toastMarging, specifier: "%.0f")")
                    Divider()
                    Slider(value: $appState.toastMarging, in: 0...300) {
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
                    Divider()
                    Slider(value: $appState.toastFontSize, in: 1...64) {
                    } minimumValueLabel: {
                        Text("1")
                    } maximumValueLabel: {
                        Text("64")
                    }
                    .controlSize(.mini)
                }
                Toggle("Show Title", isOn: $appState.toastShowTitle)
                    .toggleStyle(.switch)
                Toggle("Show Content", isOn: $appState.toastShowCopyContent)
                    .toggleStyle(.switch)
                ColorPicker("Text Color", selection: $appState.toastTextColor)
                ColorPicker("Background Color", selection: $appState.toastBgColor)
                HStack {
                    Spacer(minLength: 0)
                    VStack {
                        Spacer(minLength: 20)
                        ToastView(text: SettingsView.sampleText, appState: appState)
                            .padding(appState.toastMarging)
                    }
                }
                .background(
                    Rectangle()
                        .fill(Color.black)
                        .padding(.bottom, 1)
                        .padding(.trailing, 1)
                        .background(Color.blue)
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
        }
    }

    private var soundSettings: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Tost Volume")
                Text("\(appState.soundVolume * 100, specifier: "%.0f")")
                Divider()
                Slider(value: $appState.soundVolume, in: 0...1) {
                } minimumValueLabel: {
                    Text("0")
                } maximumValueLabel: {
                    Text("100")
                }
                .controlSize(.mini)
            }
            .fixedSize(horizontal: false, vertical: true)
            HStack {
                Text("Toast Sound")
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
            Spacer()
        }
    }

    private func iconName(for section: Section) -> String {
        switch section {
//        case .general: return "gearshape"
//        case .shortcuts: return "keyboard"
        case .toast: return "bubble.left.and.bubble.right"
        case .sounds: return "speaker.wave.3"
        }
    }
    
    private static let sampleText = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
}



#Preview {
    SettingsView(appState: AppState())
}
