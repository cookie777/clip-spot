import SwiftUI


struct ToastView: View {
    let text: String
    @ObservedObject var appState: AppState

    var body: some View {
        VStack {
            if appState.toastShowTitle {
                HStack {
                    Text("Copied to Clipboard")
                        .foregroundStyle(appState.toastTextColor.opacity(0.4))
                        .font(.caption.bold())
                    Spacer()
                }
            }
            VStack {
                Spacer(minLength: 0)
                Text(text)
                    .foregroundStyle(appState.toastTextColor)
                    .font(.system(size: appState.toastFontSize))
                Spacer(minLength: 0)
            }

            
        }
        .padding(12)
        .frame(width: appState.toastWidth, height: appState.toastHeight)
        .background(appState.toastBgColor)
        .cornerRadius(12)
        .opacity(appState.toastOpacity)
    }
}

#Preview {
    let appState = AppState()
    ToastView(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.", appState: appState)
    
    Button("toggle title") {
        appState.toastShowTitle.toggle()
    }
}
