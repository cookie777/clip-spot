import SwiftUI

struct SettingsView: View {
    
    enum Section: String, CaseIterable, Identifiable {
        case general = "General"
        case toast = "Toast"
        case sounds = "Sound"
        
        var id: String { rawValue }
    }

    @State private var selectedSection: Section? = .toast
    
    var body: some View {
        NavigationSplitView {
            List(Section.allCases, id: \.self, selection: $selectedSection) { section in
                Label(section.rawValue, systemImage: iconName(for: section))
            }
            .listStyle(.sidebar)
            .frame(minWidth: 150)

        } detail: {
            switch selectedSection {
            case .general:
                inject { appState, diContainer in
                    SettingGeneralView(
                        appState: appState,
                        launchAtLoginService: diContainer.launchAtLoginService
                    )
                }
            case .toast:
                inject { appState, _ in
                    SettingToastView(appState: appState)
                        .padding()
                }
            case .sounds:
                inject { appState, _ in
                    SettingSoundView(appState: appState)
                        .padding()
                }
            case .none:
                Text("Select a section")
                    .padding()
            }
        }
        .navigationTitle(selectedSection?.rawValue ?? "")
        .toolbar(.hidden)
    }

    private func iconName(for section: Section) -> String {
        switch section {
        case .general: return "gearshape"
//        case .shortcuts: return "keyboard"
        case .toast: return "bubble.left.and.bubble.right"
        case .sounds: return "speaker.wave.3"
        }
    }
}

#Preview {
    SettingsView()
        .environment(\.diContainer, DIContainer())
        .environmentObject(AppState())
}
