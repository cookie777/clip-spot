import SwiftUI


struct ToastView: View {
//    let text: String
    @ObservedObject var appState: AppState
    @ObservedObject  var viewModel: ToastViewModel
    
    init(appState: AppState, viewModel: ToastViewModel) {
        self.appState = appState
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            Spacer(minLength: 0)
                .renderIf(appState.toastPosition.isBottom)
            HStack {
                Spacer(minLength: 0)
                    .renderIf(appState.toastPosition.isRight)
                VStack {
                    Text("Copied to Clipboard")
                        .foregroundStyle(appState.toastTextColor.opacity(0.4))
                        .font(.caption.bold())
                        .renderIf(appState.toastShowTitle)
                    Text(viewModel.copyText)
                        .foregroundStyle(appState.toastTextColor)
                        .font(.system(size: appState.toastFontSize))
                }
                .padding(12)
                .applyIf(!appState.toastDynamicSize){
                    $0.frame(width: appState.toastWidth, height: appState.toastHeight)
                }
                .background(appState.toastBgColor)
                .cornerRadius(12)
                
                
                Spacer(minLength: 0)
                    .renderIf(appState.toastPosition.isLeft)
            }
            Spacer(minLength: 0)
                .renderIf(appState.toastPosition.isTop)
        }
        .frame(width: appState.toastWidth, height: appState.toastHeight)
    }
}

#Preview {
    let appState = AppState()
    VStack {
        ToastView(appState: appState, viewModel: ToastViewModel(appState: appState, copyText: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."))
            .onAppear {
                appState.toastShowTitle = true
                appState.toastShowCopyContent = false
            }
        
        ToastView(appState: appState, viewModel: ToastViewModel(appState: appState, copyText: "Lorem Ipsum"))
            .onAppear {
                appState.toastShowTitle = true
                appState.toastShowCopyContent = false
            }
        
        Button("toggle title") {
            appState.toastShowTitle.toggle()
        }
    }
    .background(Color.blue)
}
